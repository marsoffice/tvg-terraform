output "endpoint" {
    value = azurerm_cognitive_account.account.endpoint
    sensitive = true
}

output "key" {
    value = azurerm_cognitive_account.account.primary_access_key
    sensitive = true
}