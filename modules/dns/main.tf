terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group
}

resource "azurerm_dns_cname_record" "app_cname" {
  name                = var.cname
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group
  ttl                 = 300
  record              = var.cname_value
}

resource "azurerm_dns_cname_record" "landing_cname" {
  name                = var.cname_landing
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group
  ttl                 = 300
  record              = var.cname_landing_value
}