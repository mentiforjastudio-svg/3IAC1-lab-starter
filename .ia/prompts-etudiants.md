# Prompts IA — 3IAC1
# Coller ces prompts dans GitHub Copilot Chat ou Claude
# pour obtenir de l'aide ciblée sur les TPs.

---

## TERRAFORM — Aide générale

### Expliquer une ressource
```
Je suis étudiant en formation 3IAC1 (Terraform local, pas de cloud).
Explique-moi cette ressource Terraform :
[COLLER LE CODE ICI]
```

### Déboguer un plan Terraform
```
J'ai cette erreur dans terraform plan :
[COLLER L'ERREUR ICI]
Mon fichier main.tf :
[COLLER LE CODE ICI]
Je n'utilise que le provider hashicorp/local. Qu'est-ce qui ne va pas ?
```

### Comprendre le state
```
En formation 3IAC1, j'ai lancé terraform apply et un fichier terraform.tfstate
a été créé. Explique-moi en 5 lignes à quoi il sert et pourquoi
on ne le committe jamais dans Git.
```

---

## TERRAFORM — TP spécifiques

### TP1 — Créer un fichier avec Terraform
```
Dans mon TP1 Terraform (provider local uniquement), je veux créer un fichier
texte avec le contenu "Bonjour depuis Terraform" dans le dossier output/.
Montre-moi la ressource local_file avec les variables app_name et environment.
```

### TP2 — Sécurité des secrets
```
Je veux passer un mot de passe à Terraform sans l'écrire dans le code.
Montre-moi comment déclarer une variable sensitive et la passer
via une variable d'environnement TF_VAR_xxx.
```

### TP3 — Module Terraform
```
Je veux créer un module Terraform local appelé "config-generator"
qui prend app_name, environment et port en entrée
et génère un fichier JSON dans output_dir.
Montre-moi les fichiers main.tf, variables.tf et outputs.tf du module,
et comment l'appeler deux fois depuis le main.tf parent.
```

---

## ANSIBLE — Aide générale

### Expliquer un playbook
```
Je suis étudiant en formation 3IAC1 (Ansible local, ansible_connection=local).
Explique-moi ce playbook ligne par ligne :
[COLLER LE PLAYBOOK ICI]
```

### Déboguer Ansible
```
J'ai cette erreur quand je lance ansible-playbook :
[COLLER L'ERREUR ICI]
Mon playbook :
[COLLER LE PLAYBOOK ICI]
J'utilise ansible_connection=local et become: no. Qu'est-ce qui ne va pas ?
```

### Comprendre l'idempotence
```
En formation 3IAC1, explique-moi ce qu'est l'idempotence en Ansible
avec un exemple concret utilisant le module file ou copy.
Montre ce qui se passe quand on relance le playbook deux fois.
```

---

## ANSIBLE — TP spécifiques

### TP4 — Inventaire et ping
```
Je débute avec Ansible en local (ansible_connection=local).
Montre-moi le contenu minimal de :
1. ansible/inventories/hosts.ini
2. ansible/ansible.cfg
Et la commande pour tester la connexion avec ansible all -m ping.
```

### TP5 — Premier playbook
```
Je veux écrire mon premier playbook Ansible qui :
- crée un dossier output/config/
- y crée un fichier app.conf avec les variables app_name et app_version
- liste les fichiers créés avec le module find et les affiche avec debug
Tout se passe en local (become: no, ansible_connection=local).
```

### TP Jinja2 — Template JSON
```
Je veux créer un template Jinja2 qui génère un fichier config.json.
Il doit contenir app_name, environment, port, et une liste de features.
Montre-moi le fichier .j2 et le playbook qui l'utilise avec le module template.
```

### TP Rôles — Créer un rôle
```
Je veux créer un rôle Ansible local appelé "app-config" qui :
- prend app_name, app_version et app_environment comme variables (defaults)
- crée trois dossiers : config/, logs/, data/
- génère un fichier app.conf depuis un template Jinja2
- a un handler "Recharger configuration" déclenché quand le template change
Montre-moi chaque fichier : defaults/main.yml, tasks/main.yml,
handlers/main.yml, templates/app.conf.j2.
```

---

## TP FINAL — Intégration Terraform + Ansible

### Générer l'inventaire depuis Terraform
```
Dans mon TP final 3IAC1, Terraform doit générer le fichier
ansible/inventories/generated.ini à partir d'un template HCL.
Le template doit créer un groupe [webservers] avec N IPs simulées
(192.168.1.10, 192.168.1.11…) et ansible_connection=local.
Montre-moi le resource "local_file" et le fichier templates/inventory.tpl.
```

### Consommer l'inventaire généré
```
Mon inventaire a été généré par Terraform dans inventories/generated.ini.
Écris un playbook Ansible deploy.yml qui :
- cible le groupe webservers
- affiche l'IP et l'environnement de chaque hôte
- génère un fichier de config dans output/{{ inventory_hostname }}/
```

---

## ERREURS FRÉQUENTES

### Erreur : commande non trouvée
```
J'ai l'erreur "command not found: terraform" (ou ansible) sous Ubuntu/WSL2.
Quelles sont les étapes d'installation avec apt pour Ubuntu 22.04 ?
```

### Erreur : YAML invalide
```
Mon playbook Ansible me donne une erreur de syntaxe YAML.
Voici le fichier :
[COLLER LE FICHIER ICI]
Peux-tu identifier le problème d'indentation ou de syntaxe ?
```

### Erreur : template Terraform
```
J'ai une erreur "Invalid template" dans Terraform.
Mon fichier .tpl contient des {{ }} — est-ce correct pour Terraform ?
(Je viens d'Ansible où on utilise aussi {{ }})
```
