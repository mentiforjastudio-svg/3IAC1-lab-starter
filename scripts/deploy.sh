#!/bin/bash
# =============================================================================
# Script d'orchestration Terraform + Ansible — TP Final 3IAC1
# Usage : ./scripts/deploy.sh [environment] [instance_count]
# Exemple : ./scripts/deploy.sh production 3
# =============================================================================
set -e  # Arrêt immédiat en cas d'erreur

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TERRAFORM_DIR="$PROJECT_DIR/terraform/tp-final"
ANSIBLE_DIR="$PROJECT_DIR/ansible"

ENVIRONMENT="${1:-development}"
INSTANCE_COUNT="${2:-2}"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   Déploiement Infrastructure 3IAC1           ║"
echo "╚══════════════════════════════════════════════╝"
echo "  Environnement : $ENVIRONMENT"
echo "  Serveurs      : $INSTANCE_COUNT"
echo "  Projet        : $PROJECT_DIR"
echo ""

# ── Étape 1 : Terraform ───────────────────────────────────────────────────────
echo "[ 1/3 ] Provisioning avec Terraform..."
cd "$TERRAFORM_DIR"

terraform init -input=false -no-color
terraform plan \
  -var="environment=$ENVIRONMENT" \
  -var="instance_count=$INSTANCE_COUNT" \
  -out=tfplan \
  -no-color
terraform apply -auto-approve tfplan -no-color
rm -f tfplan

echo "       ✓ Infrastructure provisionnée"
echo "       ✓ Inventaire Ansible généré"
echo ""

# ── Étape 2 : Vérification de l'inventaire ────────────────────────────────────
INVENTORY="$ANSIBLE_DIR/inventories/generated.ini"
if [ ! -f "$INVENTORY" ]; then
  echo "ERREUR : l'inventaire $INVENTORY n'a pas été généré par Terraform."
  exit 1
fi

echo "[ 2/3 ] Vérification de la connectivité Ansible..."
cd "$ANSIBLE_DIR"
ansible -i inventories/generated.ini all -m ping
echo "       ✓ Ping OK"
echo ""

# ── Étape 3 : Ansible ─────────────────────────────────────────────────────────
echo "[ 3/3 ] Configuration avec Ansible..."
ansible-playbook \
  -i inventories/generated.ini \
  playbooks/deploy.yml \
  -e "app_name=InfraApp app_version=2.0.0"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   Déploiement terminé avec succès !          ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "  Fichiers générés dans : $PROJECT_DIR/output/"
echo "  Consultez les configs : ls -R $PROJECT_DIR/output/"
echo ""
