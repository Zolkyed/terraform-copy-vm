terraform {

  required_version = ">= 0.14.0"

  required_providers {
    proxmox = {
      source = "registry.example.com/telmate/proxmox"
      version = ">=1.0.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.56:8006/api2/json"
  pm_api_token_id = "root@pam!root"
  pm_api_token_secret = "fda81b85-bca7-4a68-aa00-bf858b75e9f4"
  pm_tls_insecure = true
}


variable "count_t" {
    type = number
    default = 1
}

variable "ram_t" {
    type = number
    default = 4096
}

variable "vmid_t" {
    type = number
    default = 9000
}

variable "template_name_t" {
    type = string
    default = "test"
}

variable "node_t" {
    type = string
    default = "pve"
}

variable "storage_t" {
    type = string
    default = "local-lvm"
}

variable "net_int_t" {
    type = string
    default = "vmbr0"
}

variable "cpu_t" {
    type = number
    default = 2
}

variable "vlan_tag_t" {
    type = number
    default = -1
}

variable "disk_t" {
    type = string
    default = "35G"
}

variable "user_t" {
    type = string
    default = "test"
}

variable "copy_name" {
    type = string
    default = "COPIE-DE-"
}

variable "socket_t" {
    type = number
    default = 2
}