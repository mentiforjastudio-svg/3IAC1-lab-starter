# modules/config-generator/variables.tf
variable "app_name" {
  description = "Nom de l'application"
  type        = string
}

variable "environment" {
  description = "Environnement (development, staging, production)"
  type        = string
}

variable "port" {
  description = "Port de l'application"
  type        = number
  default     = 8080
}

variable "filename" {
  description = "Nom du fichier de configuration généré"
  type        = string
  default     = "config.json"
}

variable "output_dir" {
  description = "Répertoire de sortie (doit exister ou être créé par Terraform)"
  type        = string
}
