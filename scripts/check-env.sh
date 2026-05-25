#!/bin/bash
# =============================================================================
# Script de vérification de l'environnement — à lancer en tout début de J1
# Usage : ./scripts/check-env.sh
# =============================================================================

ERRORS=0
WARNINGS=0

check_command() {
  local cmd="$1"
  local min_version="$2"
  local label="${3:-$cmd}"

  if command -v "$cmd" &>/dev/null; then
    local version
    version="$($cmd --version 2>&1 | head -1)"
    echo "  ✓ $label : $version"
  else
    echo "  ✗ $label : NON TROUVÉ"
    ERRORS=$((ERRORS + 1))
  fi
}

check_python() {
  if command -v python3 &>/dev/null; then
    local version
    version="$(python3 --version 2>&1)"
    echo "  ✓ Python3 : $version"
  else
    echo "  ✗ Python3 : NON TROUVÉ (requis par Ansible)"
    ERRORS=$((ERRORS + 1))
  fi
}

check_dir() {
  local dir="$1"
  local label="$2"
  if [ -d "$dir" ]; then
    echo "  ✓ $label : $dir"
  else
    echo "  ⚠ $label : $dir absent (sera créé par les TPs)"
    WARNINGS=$((WARNINGS + 1))
  fi
}

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   Vérification environnement 3IAC1           ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

echo "── Outils requis ─────────────────────────────"
check_command "terraform"  "1.5"
check_command "ansible"    "2.15"
check_command "git"        "2"
check_python

echo ""
echo "── Outils optionnels ─────────────────────────"
check_command "ansible-lint" "" "ansible-lint (qualité)"
check_command "code"         "" "VS Code"
check_command "jq"           "" "jq (lecture JSON)"

echo ""
echo "── Structure du projet ───────────────────────"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
check_dir "$SCRIPT_DIR/terraform/jour1"    "terraform/jour1"
check_dir "$SCRIPT_DIR/terraform/jour2"    "terraform/jour2"
check_dir "$SCRIPT_DIR/terraform/tp-final" "terraform/tp-final"
check_dir "$SCRIPT_DIR/ansible"            "ansible/"
check_dir "$SCRIPT_DIR/ansible/roles"      "ansible/roles/"

echo ""
echo "── Fichier de configuration Ansible ──────────"
if [ -f "$SCRIPT_DIR/ansible/ansible.cfg" ]; then
  echo "  ✓ ansible/ansible.cfg présent"
else
  echo "  ✗ ansible/ansible.cfg ABSENT — Ansible ne trouvera pas l'inventaire"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "── Résultat ──────────────────────────────────"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo "  ✓ Environnement prêt — bonne formation !"
elif [ "$ERRORS" -eq 0 ]; then
  echo "  ⚠ $WARNINGS avertissement(s) — non bloquant(s)"
else
  echo "  ✗ $ERRORS erreur(s) à corriger avant de commencer les TPs"
  echo "    → Voir les slides Annexe A/B pour l'installation"
fi
echo ""
