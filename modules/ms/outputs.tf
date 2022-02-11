output "id" {
    value = azurerm_media_services_account.mediaacc.id
    sensitive = true
}

output "identity_id" {
    value = azurerm_media_services_account.mediaacc.identity[0].principal_id
}