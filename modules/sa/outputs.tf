output "id" {
    value = azurerm_storage_account.storage_account.id
}

output "name" {
    value = azurerm_storage_account.storage_account.name
}

output "location" {
    value = azurerm_storage_account.storage_account.location
}

output "resource_group" {
    value = azurerm_storage_account.storage_account.resource_group_name
}

output "access_key" {
    value = azurerm_storage_account.storage_account.primary_access_key
    sensitive = true
}

output "connection_string" {
    value = azurerm_storage_account.storage_account.primary_connection_string
    sensitive = true
}