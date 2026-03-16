variable "resource_group_name" {
  description = "Name of an existing resource group where the service principal has Contributor role"
  type        = string
  default     = "rg-demo-simple-vm"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "demo-win11-vm"
}

variable "vm_size" {
  description = "Size of the VM (must support nested virtualization, 4+ cores, 16+ GB RAM)"
  type        = string
  default     = "Standard_D8s_v6"
  # Standard_D4s_v3: 4 vCPUs, 16 GB RAM, supports nested virtualization (slowish, but cheaper)
  # Standard_D8s_v6: 8 vCPUs, 32 GB RAM, supports nested virtualization
  # Other options: Standard_D4s_v4, Standard_D4s_v5, Standard_E4s_v3
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureadmin"
}

variable "allowed_rdp_ips" {
  description = "List of IP addresses allowed to RDP into the VM (CIDR notation)"
  type        = list(string)
  default     = []
  # Example: ["203.0.113.0/32", "198.51.100.0/32"]
  # Users must add their own IPs and peer IPs manually
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Demo"
    Purpose     = "Simple VM for WSL2 and Rancher Desktop"
    ManagedBy   = "Terraform"
  }
}
