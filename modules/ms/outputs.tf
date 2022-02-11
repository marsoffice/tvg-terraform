output "id" {
    value = azurerm_media_services_account.mediaacc.id
    sensitive = false
}

output "name" {
    value = azurerm_media_services_account.mediaacc.name
}
output "resource_group" {
    value = azurerm_media_services_account.mediaacc.resource_group_name
}

output "identity_id" {
    value = azurerm_media_services_account.mediaacc.identity[0].principal_id
}