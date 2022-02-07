terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

data "azuread_client_config" "current" {}

resource "random_uuid" "r_regular_id" {}
resource "random_uuid" "r_application_id" {}

resource "azuread_application" "application" {
  display_name     = var.name
  identifier_uris  = ["https://${var.name}"]
  sign_in_audience = "AzureADMyOrg"
  owners           = [data.azuread_client_config.current.object_id]
  logo_image       = var.logo_b64

  feature_tags {
    enterprise = true
    hide = false
  }

  web {
    homepage_url = "https://${var.redirect_url}"
  }

  single_page_application {
    redirect_uris = var.include_localhost_redirect == true ? ["https://localhost:4200/", "https://${var.redirect_url}/"] : ["https://${var.redirect_url}/"]
  }

  prevent_duplicate_names = true

  lifecycle {
    ignore_changes = [
      web,
      app_role,
      required_resource_access
    ]
  }
 
  app_role {
    allowed_member_types = ["User"]
    description          = "Regular TVG role"
    display_name         = "Regular"
    enabled              = true
    value                = "Regular"
    id                   = random_uuid.r_regular_id.result
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Application TVG role"
    display_name         = "Application"
    enabled              = true
    value                = "Application"
    id                   = random_uuid.r_application_id.result
  }
}


resource "time_sleep" "wait" {
  depends_on = [azuread_application.application]

  create_duration = "60s"
}

resource "azuread_service_principal" "enterprise_app" {
  application_id               = azuread_application.application.application_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
  notes = "${var.price_per_month}"

  feature_tags {
    gallery    = true
    enterprise = true
  }

  lifecycle {
    ignore_changes = [
      app_roles
    ]
  }

  depends_on = [time_sleep.wait]
}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.application.object_id
  end_date              = "2038-01-01T00:00:00Z"
}
