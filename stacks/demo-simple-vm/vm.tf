# Windows 11 Virtual Machine with Nested Virtualization Support
resource "azurerm_windows_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.admin_password.result

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  # Windows 11 Pro image
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-25h2-pro"
    version   = "latest"
  }

  # Premium SSD for OS disk
  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  # Enable boot diagnostics
  boot_diagnostics {
    storage_account_uri = null
  }

  # Additional VM settings
  enable_automatic_updates = true
  patch_mode               = "AutomaticByOS"
  timezone                 = "UTC"

  tags = var.tags
}

# Note: Nested virtualization is automatically supported on Dv3, Dv4, Dv5, Ev3, Ev4, Ev5 series VMs
# The Standard_D4s_v3 (default) supports nested virtualization out of the box
# No additional configuration is needed for WSL2 and Rancher Desktop
