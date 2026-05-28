# modules/config-generator/outputs.tf
output "config_path" {
  description = "Chemin absolu du fichier de configuration généré"
  value       = local_file.config.filename
}

output "readme_path" {
  description = "Chemin absolu du README généré"
  value       = local_file.readme.filename
}
