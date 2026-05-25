# Déclarer les variables utilisées dans main.tf
variable "app_name" {
  type    = string
  default = "demo"
}

variable "environment" {
  type    = string
  default = "dev"
}

# Variable sensible — ne jamais écrire la valeur ici
# Passer via : export TF_VAR_demo_password="valeur"
variable "demo_password" {
  type      = string
  sensitive = true
  default   = ""
}
