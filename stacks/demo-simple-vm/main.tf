terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use existing resource group (must be created beforehand)
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Random password for the VM admin user
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}:?"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}