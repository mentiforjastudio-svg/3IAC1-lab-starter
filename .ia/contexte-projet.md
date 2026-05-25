# Contexte du projet — 3IAC1
# Ce fichier est lu par GitHub Copilot et les assistants IA pour comprendre le projet.

## Identité du projet

Formation **Infrastructure as Code avec Terraform et Ansible** — 2 jours.
Niveau : Bachelor 3 (B3) — École IT.
Public : étudiants ayant des bases Linux, Docker, YAML.
Contrainte clé : **pas d'accès à un cloud public** (pas de carte bancaire).
Tous les TP tournent en **local** avec le provider `local` de Terraform et
`ansible_connection=local` pour Ansible.

## Stack technique

- Terraform 1.5+ — provider `hashicorp/local` uniquement
- Ansible 2.15+ — connexion locale, pas de SSH
- OS cible des TP : Ubuntu 22.04 LTS (WSL2, VirtualBox, UTM)
- Éditeur : VS Code
- Git : branche principale `main`

## Structure du projet

```
terraform/jour1/          → TP1 : local_file, variables, outputs, state
terraform/jour2/          → TP3 : module config-generator (réutilisable)
terraform/tp-final/       → TP final : génère inventaires/generated.ini
ansible/ansible.cfg       → Configuration Ansible (inventory, roles_path)
ansible/inventories/      → hosts.ini (statique) + generated.ini (Terraform)
ansible/playbooks/        → setup-system, generate-config, use-role, deploy
ansible/templates/        → Templates Jinja2 partagés
ansible/roles/app-config/ → Rôle complet : defaults/tasks/handlers/templates
scripts/                  → check-env.sh, deploy.sh, reset.sh
output/                   → Fichiers générés (ignorés par Git)
servers/                  → Métadonnées serveurs simulés (ignorées par Git)
```

## Fil rouge pédagogique

```
Terraform génère des fichiers (provider local)
    ↓
Terraform génère ansible/inventories/generated.ini
    ↓
Ansible lit l'inventaire et configure les "serveurs" (localement)
    ↓
Les fichiers de config apparaissent dans output/
```

## Conventions de code

### Terraform
- Indentation : 2 espaces
- Nommage ressources : snake_case
- Variables : toujours déclarées dans variables.tf avec description
- Outputs : toujours dans outputs.tf
- Secrets : jamais dans le code — passer par TF_VAR_xxx ou variables sensibles
- Pas de cloud provider : utiliser uniquement `hashicorp/local`

### Ansible
- Indentation : 2 espaces (YAML strict)
- `become: no` — pas de sudo (environnement local étudiant)
- `ansible_connection=local` dans tous les inventaires
- `host_key_checking = False` dans ansible.cfg
- Chemins : toujours relatifs à `playbook_dir` ou `role_path`
- Templates : extension `.j2`, commentaire en tête indiquant qu'ils sont générés

### Scripts shell
- `set -e` en début de script
- Messages clairs avec ✓ / ✗ / ⚠
- Confirmation avant toute action destructive

## Ce que l'IA NE doit PAS suggérer

- Ressources AWS, Azure, GCP (pas de cloud dans ce projet)
- `become: yes` ou `sudo` dans les playbooks
- Clés SSH, paires de clés, security groups
- `terraform.tfvars` avec des valeurs sensibles committées
- Des providers Terraform autres que `hashicorp/local`
- La commande `ansible-playbook` sans `-i inventories/hosts.ini`
  (sauf pour le TP final qui utilise generated.ini)

## Erreurs fréquentes à anticiper

1. `command not found: terraform` → voir scripts/check-env.sh et slides Annexe B
2. `command not found: ansible` → idem
3. `ansible all -m ping` échoue → vérifier que ansible/ansible.cfg existe
   et que le terminal est ouvert dans le dossier `ansible/`
4. `Error: Invalid template` dans Terraform → vérifier la syntaxe du .tpl
   (les variables HCL utilisent `${var}`, pas `{{ var }}` comme Jinja2)
5. `YAML IndentationError` → Ansible est strict : 2 espaces, jamais de tabulations

## Lexique pédagogique

| Terme          | Définition courte                                              |
|---------------|----------------------------------------------------------------|
| IaC           | Infrastructure as Code — décrire l'infra dans des fichiers    |
| HCL           | HashiCorp Configuration Language — langage de Terraform        |
| tfstate       | Fichier d'état Terraform — ne jamais committer                 |
| provider      | Plugin Terraform qui parle à une API (ici : local)             |
| module        | Bloc Terraform réutilisable avec inputs/outputs                |
| workspace     | Environnement isolé dans Terraform (dev/prod)                  |
| playbook      | Fichier YAML Ansible décrivant des tâches                      |
| inventaire    | Liste des hôtes Ansible (hosts.ini ou generated.ini)           |
| rôle          | Ensemble de tâches/templates/handlers réutilisables            |
| handler       | Tâche Ansible déclenchée uniquement si notifiée                |
| template j2   | Fichier Jinja2 — variables entre {{ }} et blocs {% %}          |
| idempotence   | Relancer plusieurs fois donne le même résultat                 |
