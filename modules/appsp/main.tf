terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  kind                = "FunctionApp"
  reserved = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
