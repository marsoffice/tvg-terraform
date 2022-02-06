terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  location = var.location
  name = var.name
  resource_group_name = var.resource_group
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.key_vault.id
  for_each = var.secrets
}