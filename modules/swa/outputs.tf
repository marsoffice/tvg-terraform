output "id" {
    value = azurerm_static_site.static_web_app.id
}

output "hostname" {
    value = azurerm_static_site.static_web_app.default_host_name
}

output "name" {
    value = azurerm_static_site.static_web_app.name
}

output "api_key" {
    value = azurerm_static_site.static_web_app.api_key
}