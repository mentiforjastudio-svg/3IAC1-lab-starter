# Inventaire Ansible généré par Terraform
# Environnement : ${deploy_environment}
# NE PAS MODIFIER MANUELLEMENT — ce fichier est écrasé à chaque terraform apply

[local]
localhost ansible_connection=local

[docker_hosts]
localhost ansible_connection=local

[all:vars]
deploy_environment=${deploy_environment}
ansible_python_interpreter=/usr/bin/python3
