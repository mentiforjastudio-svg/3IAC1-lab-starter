# =============================================================================
# TP 3IAC1 — Infrastructure 3-tiers Docker
# outputs.tf — Sorties Terraform
# =============================================================================

output "nginx_url" {
  description = "URL d'accès à l'application via Nginx"
  value       = "http://localhost"
}

output "flask_container_name" {
  description = "Nom du conteneur Flask (pour proxy_pass dans Nginx)"
  value       = docker_container.flask_app.name
}

output "db_network_internal" {
  description = "Confirm que db_net est bien internal=true"
  # TODO : que faut-il afficher ici pour vérifier que db_net est internal ?
  value       = docker_network.db_net.internal
}

output "ansible_inventory_path" {
  description = "Chemin du fichier d'inventaire généré"
  value       = local_file.ansible_inventory.filename
}
