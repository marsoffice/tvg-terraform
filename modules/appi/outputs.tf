output "instrumentation_key" {
  sensitive = true
  value     = azurerm_application_insights.appi.instrumentation_key
}
output "workspace_id" {
  sensitive = true
  value     = azurerm_log_analytics_workspace.workspace.id
}
