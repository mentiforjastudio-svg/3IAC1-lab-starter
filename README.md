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

---

## Pour les formateurs — Créer une OVA Ubuntu préparée

Ce projet peut être distribué sous forme d'une **OVA (Open Virtualization Appliance)** complètement configurée avec tous les outils et dépendances préinstallés.

### Avantages de l'approche OVA

✓ Les étudiants commencent directement les TP, sans attendre les installations  
✓ Environnement garanti identique pour tous  
✓ Réduction du temps de troubleshooting première connexion  
✓ Facile à dupliquer et à distribuer  

### Créer une OVA

Voir le guide complet : [**.guide_ova/GUIDE-OVA-CREATION.md**](./.guide_ova/GUIDE-OVA-CREATION.md)

> Le dossier `.guide_ova` contient les fichiers de production de l'OVA pour le formateur : guide, scripts et cloud-init. Il n'est pas nécessaire aux étudiants pour faire les TP.

**Résumé rapide :**

```bash
# 1. Créer une VM Ubuntu 22.04 (VirtualBox ou UTM)
#    Memory: 8 GB, CPUs: 4, Disk: 50 GB

# 2. Installer Ubuntu + Terraform + Ansible
#    Utiliser le fichier .guide_ova/cloud-init-setup.yaml
#    ou exécuter manuellement les commandes

# 3. Cloner le dépôt 3IAC1-lab-starter dans ~/projects/

# 4. Arrêter la VM et exporter en OVA
VBoxManage export "3iac1-lab-ubuntu-22.04" -o "3iac1-ubuntu-22.04-prepared.ova"
```

**Taille finale :** ~3-4 GB (compressée)

### Distribuer l'OVA aux étudiants

Les étudiants importent simplement l'OVA :

- **VirtualBox** : File → Import Appliance
- **UTM** : Drag & drop l'OVA

Puis démarrent la VM et vérifient l'environnement :

```bash
cd ~/projects/3IAC1-lab-starter
bash scripts/check-env.sh
```

---
