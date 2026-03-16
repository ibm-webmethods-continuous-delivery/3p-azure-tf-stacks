output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_windows_virtual_machine.main.name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_windows_virtual_machine.main.id
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = var.admin_username
}

output "admin_password" {
  description = "Admin password for the VM (sensitive)"
  value       = random_password.admin_password.result
  sensitive   = true
}

output "rdp_connection_string" {
  description = "RDP connection string"
  value       = "mstsc /v:${azurerm_public_ip.main.ip_address}"
}

output "vm_size" {
  description = "Size of the VM"
  value       = azurerm_windows_virtual_machine.main.size
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = data.azurerm_resource_group.main.location
}
