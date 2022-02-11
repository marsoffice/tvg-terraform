output "subscription_id" {
    sensitive = true
    value = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
    sensitive = true
    value = data.azurerm_client_config.current.tenant_id
}


output "domain_name" {
    sensitive = true
    value = data.azuread_domains.aad_domains.domains[0].domain_name
}