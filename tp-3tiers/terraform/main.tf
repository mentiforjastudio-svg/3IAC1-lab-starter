# =============================================================================
# TP 3IAC1 — Infrastructure 3-tiers Docker
# main.tf — Ressources principales
# =============================================================================

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.5"
}

provider "docker" {
  # Sur Linux/OVA : host = "unix:///var/run/docker.sock"
  host = "unix:///var/run/docker.sock"
}

# =============================================================================
# ÉTAPE 1 — RÉSEAUX DOCKER
# Objectif : isoler les tiers. db_net doit être interne (pas d'accès internet).
# =============================================================================

# TODO Q2 : Créer les 3 réseaux Docker
# - dmz_net  : réseau d'entrée (public-facing)
# - app_net  : réseau applicatif (Flask ↔ BDD)
# - db_net   : réseau base de données (INTERNE — internal = true)

resource "docker_network" "dmz_net" {
  name = "dmz_net"
  # TODO : faut-il ajouter internal = true ici ? Pourquoi ?
}

resource "docker_network" "app_net" {
  name = "app_net"
}

resource "docker_network" "db_net" {
  name     = "db_net"
  internal = true
}

# =============================================================================
# ÉTAPE 2 — VOLUMES PERSISTANTS
# =============================================================================

resource "docker_volume" "pg_data" {
  name = "pg_data"
}

# =============================================================================
# ÉTAPE 3 — CONTENEURS
# =============================================================================

# ── PostgreSQL ────────────────────────────────────────────────────────────────
resource "docker_container" "postgres" {
  name    = "postgres"
  image   = var.postgres_image
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.db_net.name
  }

  volumes {
    volume_name    = docker_volume.pg_data.name
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  # Pas de bloc ports {} : PostgreSQL n'est pas accessible depuis l'hôte (isolation db_net)
}

# ── Redis ─────────────────────────────────────────────────────────────────────
resource "docker_container" "redis" {
  name    = "redis"
  image   = var.redis_image
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.db_net.name
  }
}

# ── Flask App ─────────────────────────────────────────────────────────────────
resource "docker_container" "flask_app" {
  name    = "flask_app"
  image   = var.flask_image
  restart = "unless-stopped"

  # Flask doit être sur app_net ET db_net
  networks_advanced {
    name = docker_network.app_net.name
  }
  networks_advanced {
    name = docker_network.db_net.name
  }

  env = [
    "FLASK_ENV=${var.deploy_environment}",
    "DATABASE_URL=postgresql://${var.db_user}:${var.db_password}@postgres:5432/${var.db_name}",
    "REDIS_URL=redis://redis:6379/0",
  ]

  depends_on = [
    docker_container.postgres,
    docker_container.redis,
  ]
}

# ── Nginx ─────────────────────────────────────────────────────────────────────
resource "docker_container" "nginx" {
  name    = "nginx"
  image   = var.nginx_image
  restart = "unless-stopped"

  # Nginx expose le port 80 vers l'hôte ET est sur dmz_net + app_net
  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = docker_network.dmz_net.name
  }
  networks_advanced {
    name = docker_network.app_net.name
  }

  # La config Nginx sera montée via Ansible après le déploiement Terraform
  # TODO (bonus) : utiliser templatefile() pour générer une config nginx minimale

  depends_on = [docker_container.flask_app]
}

# =============================================================================
# ÉTAPE 4 — GÉNÉRATION DE L'INVENTAIRE ANSIBLE
# =============================================================================

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventories/generated.ini"
  content  = templatefile("${path.module}/templates/inventory.tpl", {
    deploy_environment = var.deploy_environment
  })

  depends_on = [
    docker_container.nginx,
    docker_container.flask_app,
    docker_container.postgres,
  ]
}
