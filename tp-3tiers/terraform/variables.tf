# =============================================================================
# TP 3IAC1 — Infrastructure 3-tiers Docker
# variables.tf — Déclaration des variables
# =============================================================================

# ── Image Docker de l'application Flask ──────────────────────────────────────
variable "flask_image" {
  description = "Image Docker pour l'application Flask"
  type        = string
  default     = "python:3.11-slim"
}

# ── Image Nginx ───────────────────────────────────────────────────────────────
variable "nginx_image" {
  description = "Image Docker pour le reverse proxy Nginx"
  type        = string
  default     = "nginx:alpine"
}

# ── Image PostgreSQL ──────────────────────────────────────────────────────────
variable "postgres_image" {
  description = "Image Docker pour la base de données"
  type        = string
  default     = "postgres:15-alpine"
}

# ── Image Redis ───────────────────────────────────────────────────────────────
variable "redis_image" {
  description = "Image Docker pour le cache Redis"
  type        = string
  default     = "redis:7-alpine"
}

# ── Base de données ───────────────────────────────────────────────────────────
variable "db_name" {
  description = "Nom de la base de données PostgreSQL"
  type        = string
  default     = "appdb"
}

variable "db_user" {
  description = "Utilisateur PostgreSQL"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Mot de passe PostgreSQL — NE PAS mettre en dur, utiliser TF_VAR_db_password"
  type        = string
  sensitive   = true
  # TODO : Déclarer cette variable comme sensitive=true et ne jamais lui donner de default
}

# ── Environnement ─────────────────────────────────────────────────────────────
variable "deploy_environment" {
  description = "Environnement de déploiement (dev / staging / prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.deploy_environment)
    error_message = "La valeur doit être : dev, staging ou prod."
  }
}
