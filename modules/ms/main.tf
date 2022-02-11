terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_media_services_account" "mediaacc" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  storage_account {
    id         = var.storage_account_id
    is_primary = true
  }
}