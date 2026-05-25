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
  filename = "${path.module}/hello.txt"
  content  = "Hello from Terraform !"
}

output "file_path" {
  value = local_file.hello.filename
}
