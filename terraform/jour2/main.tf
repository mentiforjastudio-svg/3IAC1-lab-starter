terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# TP3 — Appel du module config-generator pour l'environnement dev
module "config_dev" {
  source      = "./modules/config-generator"
  app_name    = "MonApp"
  environment = "development"
  port        = 3000
  output_dir  = "${path.module}/../../output/dev"
}

# TP3 — Même module, paramètres différents pour prod
module "config_prod" {
  source      = "./modules/config-generator"
  app_name    = "MonApp"
  environment = "production"
  port        = 80
  output_dir  = "${path.module}/../../output/prod"
}

output "dev_config_path" {
  value = module.config_dev.config_path
}

output "prod_config_path" {
  value = module.config_prod.config_path
}
