output "application_id" {
  value = azuread_application.application.application_id
}

output "object_id" {
  value = azuread_application.application.object_id
}

output "sp_object_id" {
  value = azuread_service_principal.enterprise_app.object_id
}

output "application_secret" {
  value     = azuread_application_password.application_password.value
  sensitive = true
}

output "audience" {
  value = "https://${var.name}"
}

output "issuer" {
  value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/"
}


output "internal_role_id" {
  value = random_uuid.r_application_id.result
}
