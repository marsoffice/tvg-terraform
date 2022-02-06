output "id" {
  value = azurerm_dns_zone.dns_zone.id
}

output "name" {
  value = azurerm_dns_zone.dns_zone.name
}

output "cname_hostname" {
  value = "${var.cname}.${azurerm_dns_zone.dns_zone.name}"
}
