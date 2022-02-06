output "id" {
    value = azurerm_function_app.function_app.id
}

output "hostname" {
    value = azurerm_function_app.function_app.default_hostname
}