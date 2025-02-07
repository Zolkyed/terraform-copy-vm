resource "proxmox_vm_qemu" "test" {
  
    agent = 1
    onboot = true
    desc = "Copie Template"
    count = var.count_t

    target_node = var.node_t
    vmid = count.index + var.vmid_t
    name = "${var.copy_name}-${count.index + 1}"

    ciuser = var.user_t
    cipassword = random_password.vm_password[count.index].result

    clone = var.template_name_t

    cores = var.cpu_t
    sockets = var.socket_t
    cpu = "host"

    memory = var.ram_t

    network {
      bridge = var.net_int_t
      model = "virtio"
      tag = var.vlan_tag_t
    }

    disk {
      type    = "disk"
      size    = var.disk_t  
      storage = var.storage_t
      format  = "raw"
      cache   = "none"
      backup  = true
      slot    = "scsi0"
    }

    disk {
      type    = "cloudinit"
      storage = var.storage_t
      format  = "raw"
      slot    = "ide0"
    }

    os_type = "cloud-init"

    ipconfig0 = "dhcp"
}

resource "random_password" "vm_password" {
  count  = var.count_t
  length = 16
  special = true
  override_special = "_%@"
  min_upper = 3
  min_lower = 3
  min_numeric = 3
  min_special = 3
}

output "vm_passwords" {
  value = { for idx, vm in proxmox_vm_qemu.test : vm.name => random_password.vm_password[idx].result }
  description = "Noms des VMs avec leurs mots de passe"
  sensitive = true
}