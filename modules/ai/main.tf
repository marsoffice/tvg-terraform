terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_cognitive_account" "account" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  kind                = var.kind

  sku_name = var.sku
}