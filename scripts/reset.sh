#!/bin/bash
# =============================================================================
# Script de remise à zéro — utile entre deux TPs ou en cas de blocage
# Usage : ./scripts/reset.sh
# =============================================================================
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "⚠  Reset de l'environnement 3IAC1"
echo "   Cela supprime : output/, servers/, tfstate, inventaire généré"
echo ""
read -r -p "   Confirmer ? (oui/non) : " confirm
if [ "$confirm" != "oui" ]; then
  echo "   Annulé."
  exit 0
fi

# Supprimer les fichiers générés par Terraform
echo "   Nettoyage Terraform..."
find "$PROJECT_DIR/terraform" -name "*.tfstate" -delete
find "$PROJECT_DIR/terraform" -name "*.tfstate.*" -delete
find "$PROJECT_DIR/terraform" -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_DIR/terraform" -name ".terraform.lock.hcl" -delete 2>/dev/null || true

# Supprimer l'inventaire généré
rm -f "$PROJECT_DIR/ansible/inventories/generated.ini"

# Supprimer les dossiers de sortie
rm -rf "$PROJECT_DIR/output"/*
rm -rf "$PROJECT_DIR/servers"/*

# Recréer les .gitkeep
touch "$PROJECT_DIR/output/.gitkeep"
touch "$PROJECT_DIR/servers/.gitkeep"

echo ""
echo "   ✓ Environnement remis à zéro."
echo "   Relancez : cd terraform/jour1 && terraform init"
echo ""
