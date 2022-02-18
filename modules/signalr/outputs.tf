output "connection_string" {
    sensitive = true
    value = azurerm_signalr_service.signalr.primary_connection_string
}

output "id" {
    value = azurerm_signalr_service.signalr.id
}
