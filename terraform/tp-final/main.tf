terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "development"
}

variable "instance_count" {
  description = "Nombre de serveurs simulés"
  type        = number
  default     = 2
}

# Simuler des serveurs avec des fichiers locaux
# En cloud réel, ce serait aws_instance ou azurerm_linux_virtual_machine
resource "local_file" "server_info" {
  count    = var.instance_count
  filename = "${path.module}/../../../servers/server-${count.index}.json"
  content = jsonencode({
    id          = "server-${count.index}"
    ip          = "192.168.1.${10 + count.index}"
    environment = var.environment
    role        = "webserver"
  })
}

# Générer l'inventaire Ansible à partir du template
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../tp-03-ansible/inventories/generated.ini"
  content = templatefile("${path.module}/templates/inventory.tpl", {
    servers     = [for i in range(var.instance_count) : "192.168.1.${10 + i}"]
    environment = var.environment
  })

  # L'inventaire dépend des infos serveur
  depends_on = [local_file.server_info]
}

output "server_ips" {
  value = [for i in range(var.instance_count) : "192.168.1.${10 + i}"]
}

output "inventory_path" {
  value = local_file.ansible_inventory.filename
}

output "deploy_environment" {
  value = var.environment
}
