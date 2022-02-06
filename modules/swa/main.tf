terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "azurerm_static_site" "static_web_app" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  sku_size = var.sku_size
  sku_tier = var.sku_tier

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

locals {
  json = var.properties == null ? null : "{\"properties\": ${replace(replace(jsonencode(var.properties), "\r\n", ""), "\n","")}}"
}

data "azurerm_client_config" "current" {}

resource "null_resource" "app_settings" {
  provisioner "local-exec" {
    command = "az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID && az rest --method put --headers \"Content-Type=application/json\" --uri \"/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_static_site.static_web_app.resource_group_name}/providers/Microsoft.Web/staticSites/${azurerm_static_site.static_web_app.name}/config/functionappsettings?api-version=2019-12-01-preview\" --body '${local.json}'"
  }
  triggers = {
    always_run = jsonencode(var.properties)
  }
  count = var.properties == null ? 0 : 1

  depends_on = [
    azurerm_static_site.static_web_app
  ]
}