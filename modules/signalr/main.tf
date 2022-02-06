terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_signalr_service" "signalr" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  sku {
    name     = var.sku
    capacity = var.capacity
  }

  cors {
    allowed_origins = var.allow_localhost ? ["https://localhost:4200", var.allowed_host] : [var.allowed_host]
  }

  service_mode = "Serverless"

  lifecycle {
    ignore_changes = [
      features
    ]
  }
}
