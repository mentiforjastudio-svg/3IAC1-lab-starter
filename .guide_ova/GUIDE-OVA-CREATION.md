# Guide de création d'une OVA Ubuntu 22.04 pour 3IAC1

Ce guide explique comment créer une **OVA (Open Virtualization Appliance)** complètement configurée pour les étudiants de la formation 3IAC1.

## Prérequis

- **VirtualBox** 6.1+ ou **UTM** (macOS Apple Silicon)
- **Ubuntu 22.04 ISO** : <https://releases.ubuntu.com/22.04/>
- Environ **50 GB d'espace disque** libre
- **20-30 minutes** de temps

> Note : cette procédure crée une OVA Ubuntu x86_64 compatible VirtualBox sur Windows/Linux/Mac Intel. Elle n'est pas garantie sur un Mac Apple Silicon natif, qui nécessite un flux UTM ARM64 séparé.

---

## Méthode 1 : VirtualBox (Windows, Linux, macOS Intel)

### Étape 1 : Créer une VM de base

```bash
VBoxManage createvm \
  --name "3iac1-lab-ubuntu-22.04" \
  --ostype "Ubuntu22_64" \
  --register

VBoxManage modifyvm "3iac1-lab-ubuntu-22.04" \
  --memory 8192 \
  --cpus 4 \
  --vram 128 \
  --nic1 nat \
  --natpf1 "SSH,tcp,127.0.0.1,2222,,22"
```

Ou utiliser l'interface GUI :

1. File → New
2. Name: `3iac1-lab-ubuntu-22.04`
3. OS: Linux, Ubuntu (64-bit)
4. Memory: **8192 MB**
5. Disk: **50 GB** (dynamique ou fixe)
6. Network: **NAT** avec port forwarding (SSH: 2222 → 22)

### Option PowerShell (Windows)

Ouvre PowerShell en administrateur et exécute :

```powershell
$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

& $VBoxManage createvm `
  --name "3iac1-lab-ubuntu-22.04" `
  --ostype "Ubuntu22_64" `
  --register

& $VBoxManage modifyvm "3iac1-lab-ubuntu-22.04" `
  --memory 8192 `
  --cpus 4 `
  --vram 128 `
  --nic1 nat `
  --natpf1 "SSH,tcp,127.0.0.1,2222,,22"

& $VBoxManage createmedium disk `
  --filename "C:\Users\alaster\VirtualBox VMs\3iac1-lab-ubuntu-22.04\disk.vdi" `
  --size 51200

& $VBoxManage storagectl "3iac1-lab-ubuntu-22.04" `
  --name "SATA Controller" `
  --add sata

& $VBoxManage storageattach "3iac1-lab-ubuntu-22.04" `
  --storagectl "SATA Controller" `
  --port 0 `
  --device 0 `
  --type hdd `
  --medium "C:\Users\alaster\VirtualBox VMs\3iac1-lab-ubuntu-22.04\disk.vdi"

& $VBoxManage storagectl "3iac1-lab-ubuntu-22.04" `
  --name "IDE Controller" `
  --add ide

& $VBoxManage storageattach "3iac1-lab-ubuntu-22.04" `
  --storagectl "IDE Controller" `
  --port 0 `
  --device 0 `
  --type dvddrive `
  --medium "C:\Users\alaster\Downloads\ubuntu-22.04-live-server-amd64.iso"
```

Remplace le chemin `C:\Users\alaster\Downloads\ubuntu-22.04-live-server-amd64.iso` par le chemin réel de ton image ISO.

### Étape 2 : Installer Ubuntu 22.04

1. Démarrer la VM
2. Sélectionner l'ISO Ubuntu 22.04 Server
3. Installation rapide :
   - Language: **English**
   - Keyboard: votre clavier
   - Network: **DHCP** (automatique)
   - Hostname: `3iac1-lab`
   - Username: `student`
   - Password: `student` (ou un mot de passe sécurisé)
   - SSH Server: **✓ Activé**
   - LVM: ✗ (non nécessaire)

4. Redémarrer et se connecter

### Étape 3 : Créer un fichier cloud-init

Créer un fichier `/tmp/cloud-init/user-data.yaml` dans la VM avec le contenu du fichier `.guide_ova/cloud-init-setup.yaml` présent dans le dépôt.

Par exemple :

```bash
# Depuis la VM
mkdir -p /tmp/cloud-init
nano /tmp/cloud-init/user-data.yaml
```

Puis coller dans ce fichier le contenu de `.guide_ova/cloud-init-setup.yaml`.

### Étape 4 : Exécuter le cloud-init

Depuis la VM (avec droits sudo) :

```bash
cloud-init clean --seed
cloud-init init --local
cloud-init init
cloud-init modules --mode config
cloud-init modules --mode final
```

**Alternative simple** : se connecter à la VM et exécuter manuellement :

```bash
# SSH depuis le host
ssh -p 2222 student@127.0.0.1

# Puis sur la VM
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget gnupg

# Installer Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# Installer Ansible
sudo apt install -y ansible

# Cloner le dépôt
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/mentiforjastudio-svg/3IAC1-lab-starter.git

# Vérifier
bash ~/projects/3IAC1-lab-starter/scripts/check-env.sh
```

### Étape 5 : Exporter en OVA

Une fois la VM configurée et arrêtée :

```bash
# Sur la machine hôte
VBoxManage export "3iac1-lab-ubuntu-22.04" \
  -o "3iac1-ubuntu-22.04-prepared.ova"
```

Ou utiliser le script fourni :

```bash
cd 3iac1-lab-starter
bash .guide_ova/create-ova.sh
```

---

## Méthode 2 : UTM (macOS Apple Silicon)

### Étape 1 : Créer la VM

1. Ouvrir **UTM**
2. Create → Virtualize
3. OS: **Linux** → Ubuntu
4. Download: **Ubuntu 22.04 LTS ARM64**
5. Resources: **4 cores, 8 GB RAM, 50 GB**
6. Network: **Default NAT**

### Étape 2 : Installer Ubuntu

Même processus que VirtualBox, en choisissant l'image ARM64.

### Étape 3 : Provisionner

Copier-coller le contenu du `cloud-init-setup.yaml` manuellement via SSH ou l'exécuter directement.

### Étape 4 : Exporter

Dans UTM :

1. Clic droit sur la VM → **Edit**
2. Options → **Export**
3. Format: **OVA** (compatible VirtualBox) ou **QCOW2** (optimisé UTM)

---

> Note formateur :
> Distribuer uniquement le fichier **OVA** aux étudiants. Le dossier `.guide_ova` contient des outils et scripts de packaging qui ne sont pas nécessaires pour leur usage.

## Étape finale : Distribuer l'OVA aux étudiants

> Note formateur : distribuer uniquement le fichier **OVA** aux étudiants. Ce guide et les scripts sont réservés au formateur.
>
> Cette OVA est une image x86_64. Elle fonctionne avec VirtualBox sur Windows/Linux/Mac Intel, mais pas avec un Mac Apple Silicon natif à moins d'utiliser une VM ARM64 dédiée.

### Fichier OVA créé : `3iac1-ubuntu-22.04-prepared.ova`

**Instructions pour les étudiants :**

## Importer la OVA

### VirtualBox

1. File → Import Appliance
2. Sélectionner : `3iac1-ubuntu-22.04-prepared.ova`
3. Cliquer sur Import
4. Démarrer la VM

### UTM (Mac)

1. Drag & drop l'OVA dans UTM (ou File → Open)
2. Confirmer les paramètres
3. Démarrer

## Premiers pas après démarrage

```bash
# Se connecter
# Username: student
# Password: student

# Vérifier que tout est prêt
cd ~/projects/3IAC1-lab-starter
bash scripts/check-env.sh

# Commencer le TP1
cd terraform/jour1
terraform init
terraform plan
terraform apply
```

---

## Fichiers inclus dans l'OVA

✓ Ubuntu 22.04 LTS  
✓ Terraform 1.5+  
✓ Ansible 2.15+  
✓ Git  
✓ Dépôt 3IAC1-lab-starter (cliqué dans `~/projects/`)  
✓ Prérequis système  

---

## Dépannage

### "command not found: terraform"

Relancer le cloud-init :

```bash
sudo cloud-init clean --seed && sudo cloud-init --help
```

### Clonage Git échoue

Vérifier la connexion réseau :

```bash
ping github.com
```

### VM trop lente

Augmenter les ressources :

- Memory: 8192 → 16384 MB
- CPUs: 4 → 8

---

## Taille estimée de l'OVA

| Composant | Taille |
|-----------|--------|
| Ubuntu 22.04 | ~2 GB |
| Terraform | ~100 MB |
| Ansible | ~50 MB |
| Git + outils | ~200 MB |
| Dépôt 3IAC1 | ~50 MB |
| Espace libre | ~47 GB |
| **OVA compressée** | **~3-4 GB** |

---

## Notes

- L'OVA est **réutilisable** : chaque étudiant l'importe une fois et la VM est prête.
- Le mot de passe `student` peut être changé après création.
- L'OVA peut être stockée sur un serveur interne (Nextcloud, ShareFile, etc.).
- Pour les mises à jour futures, recréer une nouvelle OVA ou fournir un script de mise à jour.

Bon provisioning ! 🚀
