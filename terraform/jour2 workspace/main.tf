terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# TP3 — Appel du module config-generator pour l'environnement workspace_name
module "config_workspace" {
  source      = "./modules/config-generator"
  app_name    = "MonApp_${var.Workspace_Name}"
  environment = "${var.Workspace_Name}"
  port        = 3000
  output_dir  = "${path.module}/../../output/${var.Workspace_Name}"
}


output "workspace_config_path" {
  value = module.config_workspace.config_path
}

