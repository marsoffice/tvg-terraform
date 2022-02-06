terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  retention_in_days   = var.retention
}

resource "azurerm_application_insights" "appi" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  application_type    = "web"
  retention_in_days   = var.retention
  workspace_id        = azurerm_log_analytics_workspace.workspace.id
}
