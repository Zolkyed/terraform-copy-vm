
# Prérequis :
- **Terraform**
- **Serveur Proxmox**

---

# Installation de Terraform

Commencez par télécharger et installer Terraform avec les commandes suivantes :

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Ensuite, pour configurer le provider Proxmox, ajoutez le code suivant dans le fichier `providers.tf` :

```bash
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://[IP-du-Proxmox]:8006/api2/json"
  pm_api_token_id = "[TOKEN_ID]"
  pm_api_token_secret = "[TOKEN_SECRET]"
  pm_tls_insecure = true
}
```

**Remarque :** Remplacez `[IP-du-Proxmox]`, `[TOKEN_ID]`, et `[TOKEN_SECRET]` par les valeurs appropriées.

Cependant, si vous rencontrez des erreurs lors du téléchargement des plugins, vous pouvez installer manuellement le provider Proxmox en suivant les étapes ci-dessous :

```bash
git clone https://github.com/Telmate/terraform-provider-proxmox.git
cd terraform-provider-proxmox
sudo apt remove golang-go
sudo apt remove --auto-remove golang-go
wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo apt install make
make
mkdir -p ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/linux_amd64
cp terraform-provider-proxmox ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/linux_amd64
```

Si le plugin a été installé manuellement, la configuration `required_providers` doit être modifiée comme suit :

```bash
terraform {
  required_providers {
    proxmox = {
      source = "registry.example.com/telmate/proxmox"
      version = ">=1.0.0"
    }
  }
}
```

---

# Préparation de l'environnement

Le script nécessite trois fichiers pour fonctionner correctement :

```bash
.
├── clonevm.tf
├── providers.tf
└── variable.tfvars

0 directories, 3 files
```

Les trois fichiers nécessaires sont disponibles ici : [https://git.dti.crosemont.quebec/yguemar/h34_a24_pl_dona_yanni/-/tree/main/Projet_LINUX/COPIE-TEMPLATE](https://git.dti.crosemont.quebec/yguemar/h34_a24_pl_dona_yanni/-/tree/main/Projet_LINUX/COPIE-TEMPLATE)

---

# Explication du fonctionnement et utilisation

Le script Terraform permet de cloner un template Proxmox et de créer plusieurs machines virtuelles en parallèle avec les configurations souhaitées. Voici comment l'utiliser :

1. **Initialiser Terraform :**

   Naviguez dans le répertoire contenant le script et exécutez la commande suivante pour initialiser Terraform et télécharger les plugins nécessaires :

   ```bash
   terraform init
   ```

2. **Planifier la création des VMs :**

   Avant d'appliquer les changements, vous pouvez générer un plan pour voir ce qui sera créé ou modifié :

   ```bash
   terraform plan -var-file="variable.tfvars"
   ```

   Cette commande utilisera le fichier `variable.tfvars` pour charger les variables personnalisées.

3. **Appliquer la configuration :**

   Après avoir vérifié le plan, appliquez la configuration pour créer les VMs :

   ```bash
   terraform apply -var-file="variable.tfvars"
   ```

   **Remarque :** Assurez-vous que la taille du disque spécifiée dans `variable.tfvars` est égale ou supérieure à celle du template source pour éviter des erreurs de création.

4. **Obtenir les mots de passe des VMs :**

   Après la création des VMs, vous pouvez exporter les mots de passe générés dans un fichier JSON pour les consulter plus tard :

   ```bash
   terraform output -json > mdp.json
   ```

   Ce fichier contiendra les noms des VMs et leurs mots de passe associés.

---

# Personnalisation du script

Le fichier `variable.tfvars` vous permet de personnaliser les paramètres suivants pour chaque VM :

- **Nombre de VMs à créer (`count_t`)**
- **Nombre de cœurs CPU (`cpu_t`)**
- **Quantité de RAM (`ram_t`)**
- **ID de la VM (`vmid_t`)**
- **Nom du template (`template_name_t`)**
- **Node Proxmox (`node_t`)**
- **Emplacement de stockage (`storage_t`)**
- **Interface réseau (`net_int_t`)**
- **Tag VLAN (`vlan_tag_t`)**
- **Taille du disque (`disk_t`)**
- **Nom de l'utilisateur (`user_t`)**
- **Nom de la copie (`copy_name`)**

**Remarque :** Les noms de VM et leurs mots de passe sont générés automatiquement en fonction de ces variables.

---

**ATTENTION : La taille du disque doit être supérieure ou égale à celle du template**