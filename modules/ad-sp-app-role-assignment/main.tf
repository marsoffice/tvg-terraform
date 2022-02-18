terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

resource "azuread_app_role_assignment" "assignment" {
  app_role_id         = var.app_role_id
  principal_object_id = var.principal_id
  resource_object_id  = var.resource_id
}
