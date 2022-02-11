terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

data "azurerm_client_config" "current" {
}

data "azuread_domains" "aad_domains" {
  only_default = true
}