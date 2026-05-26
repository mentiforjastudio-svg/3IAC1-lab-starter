#!/bin/bash
set -e

# Script pour créer une OVA Ubuntu 22.04 pour 3IAC1
# Prérequis : VirtualBox installé sur le système hôte

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Variables
VM_NAME="3iac1-lab-ubuntu-22.04"
VM_MEMORY=8192  # 8 GB
VM_CPUS=4
VM_DISK=50000   # 50 GB
OVA_OUTPUT="3iac1-ubuntu-22.04-prepared.ova"

echo -e "${YELLOW}[3IAC1] OVA Creation Script${NC}"
echo "VM Name: $VM_NAME"
echo "Memory: $VM_MEMORY MB"
echo "CPUs: $VM_CPUS"
echo "Disk: $VM_DISK MB"
echo "Output: $OVA_OUTPUT"
echo ""

# Check if VM already exists
if VBoxManage list vms | grep -q "$VM_NAME"; then
    echo -e "${YELLOW}VM '$VM_NAME' already exists. Exporting...${NC}"
else
    echo -e "${RED}Error: VM '$VM_NAME' not found.${NC}"
    echo "Please create the VM first with VirtualBox GUI or using:"
    echo "  VBoxManage createvm --name '$VM_NAME' --ostype Ubuntu22_64 --register"
    exit 1
fi

# Power off VM if running
if VBoxManage showvminfo "$VM_NAME" | grep -q "State.*running"; then
    echo -e "${YELLOW}Powering off VM...${NC}"
    VBoxManage controlvm "$VM_NAME" poweroff
    sleep 3
fi

# Export OVA
echo -e "${YELLOW}Exporting VM to OVA...${NC}"
VBoxManage export "$VM_NAME" -o "$OVA_OUTPUT" --vmname "$VM_NAME"

# Verify export
if [ -f "$OVA_OUTPUT" ]; then
    SIZE=$(du -h "$OVA_OUTPUT" | cut -f1)
    echo -e "${GREEN}✓ OVA created successfully!${NC}"
    echo "  File: $OVA_OUTPUT"
    echo "  Size: $SIZE"
    echo ""
    echo -e "${GREEN}Next steps for students:${NC}"
    echo "  1. Import the OVA into VirtualBox"
    echo "  2. Start the VM and wait for cloud-init to complete (~2-3 min)"
    echo "  3. Login with: student / password"
    echo "  4. Run: cd ~/projects/3IAC1-lab-starter && bash scripts/check-env.sh"
else
    echo -e "${RED}✗ Export failed!${NC}"
    exit 1
fi
