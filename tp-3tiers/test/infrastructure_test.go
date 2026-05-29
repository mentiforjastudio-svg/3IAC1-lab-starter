// =============================================================================
// TP 3IAC1 — Tests d'infrastructure avec Terratest
// infrastructure_test.go
// Lancer : go test -v -timeout 10m ./...
// =============================================================================

package test

import (
	"context"
	"net/http"
	"testing"

	"github.com/docker/docker/client"
	"github.com/docker/docker/api/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestInfrastructure3Tiers(t *testing.T) {
	t.Parallel()

	// ── Configuration Terraform ──────────────────────────────────────────────
	opts := &terraform.Options{
		TerraformDir: "../terraform",
		Vars: map[string]interface{}{
			"deploy_environment": "dev",
			"db_name":            "testdb",
			"db_user":            "testuser",
		},
		EnvVars: map[string]string{
			// Le mot de passe est passé via variable d'environnement
			"TF_VAR_db_password": "test_password_ci",
		},
	}

	// Cleanup automatique, même si le test panique ou échoue à mi-parcours
	defer terraform.Destroy(t, opts)

	// ── Déploiement ──────────────────────────────────────────────────────────
	terraform.InitAndApply(t, opts)

	// ── Test 1 : db_net doit être internal=true ───────────────────────────────
	t.Run("db_net_is_internal", func(t *testing.T) {
		cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
		assert.NoError(t, err, "Impossible de créer le client Docker")
		defer cli.Close()

		net, err := cli.NetworkInspect(context.Background(), "db_net", types.NetworkInspectOptions{})
		assert.NoError(t, err, "Réseau db_net introuvable")
		assert.True(t, net.Internal, "db_net doit avoir internal=true pour isoler la BDD")
	})

	// ── Test 2 : Nginx doit répondre HTTP (502 attendu — Flask absent) ───────
	t.Run("nginx_responds_http", func(t *testing.T) {
		resp, err := http.Get("http://localhost")
		assert.NoError(t, err, "Nginx ne répond pas — vérifier que le conteneur nginx tourne")
		if resp != nil {
			defer resp.Body.Close()
			// Flask n'est pas démarré dans ce TP : 502 est le code attendu.
			// On vérifie uniquement qu'une réponse HTTP est reçue (pas de connection refused).
			assert.NotEqual(t, 0, resp.StatusCode)
		}
	})

	// ── Test 3 (bonus) : PostgreSQL ne doit pas avoir de port exposé ─────────
	t.Run("postgres_no_exposed_port", func(t *testing.T) {
		cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
		assert.NoError(t, err)
		defer cli.Close()

		containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
		assert.NoError(t, err)

		for _, c := range containers {
			for _, name := range c.Names {
				if name == "/postgres" {
					assert.Empty(t, c.Ports, "Le conteneur postgres ne doit exposer aucun port vers l'hôte")
				}
			}
		}
	})
}
