# 3IAC1 — Lab Starter

Dépôt de démarrage pour la formation **Infrastructure as Code avec Terraform et Ansible** (2 jours).

## Prérequis

```bash
git --version      # 2.x
terraform --version  # 1.5+
ansible --version    # 2.15+
```

## Structure

```
3iac1-lab-starter/
├── terraform/
│   ├── jour1/          # TP1 : local_file, variables, outputs, state
│   ├── jour2/          # TP3 : mini-module config-generator
│   └── tp-final/       # TP final : génère l'inventaire Ansible
├── ansible/
│   ├── ansible.cfg     # Configuration Ansible (inventaire, options)
│   ├── inventories/    # hosts.ini (statique) + generated.ini (généré par Terraform)
│   ├── playbooks/      # setup-system.yml, generate-config.yml, use-role.yml, deploy.yml
│   ├── templates/      # Templates Jinja2
│   └── roles/
│       └── app-config/ # Rôle Ansible réutilisable
├── output/             # Fichiers générés par les TP (ignorés par Git)
└── servers/            # Fichiers simulant des serveurs (générés par Terraform)
```

## Démarrage rapide

```bash
git clone <url-du-repo> 3iac1-lab
cd 3iac1-lab
```

### Jour 1 — Terraform

```bash
cd terraform/jour1
terraform init
terraform plan
terraform apply
```

### Jour 2 — Ansible

```bash
cd ansible
ansible all -m ping
ansible-playbook playbooks/setup-system.yml
```

### TP Final — Intégration

```bash
cd terraform/tp-final
terraform init && terraform apply
cd ../../ansible
ansible -i inventories/generated.ini all -m ping
ansible-playbook -i inventories/generated.ini playbooks/deploy.yml
```

## Notes pédagogiques

- Les dossiers `output/` et `servers/` sont dans `.gitignore` : ils contiennent les fichiers **générés** par les TP.
- Le fichier `ansible/inventories/generated.ini` est généré par Terraform — ne pas le modifier à la main.
- Les fichiers `*.tfstate` ne sont jamais committés (voir `.gitignore`).
