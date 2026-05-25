# Inventaire généré automatiquement par Terraform
# Ne pas modifier manuellement — relancer terraform apply pour mettre à jour

[webservers]
%{ for ip in servers ~}
${ip} ansible_connection=local deploy_environment=${environment}
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3
deploy_environment=${environment}
