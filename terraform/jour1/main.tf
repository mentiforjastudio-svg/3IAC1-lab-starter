terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# TP1 — Ressource de base : créer un fichier local
resource "local_file" "hello" {
  filename = "${path.module}/${var.app_name}.txt"
  content  = "Hello from Terraform ! ; Application ${var.app_name} — environnement ${var.environment}"
}

output "file_path" {
  value     = local_file.hello.filename
  sensitive = true
}
