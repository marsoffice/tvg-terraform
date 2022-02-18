terraform {
  backend "azurerm" {
    resource_group_name  = "rg-marsoffice"
    storage_account_name = "samarsoffice"
    container_name       = "tfstates"
    key                  = "tvg.prod.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.95"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {

}

module "rg" {
  source   = "../modules/rg"
  location = "West Europe"
  name     = "rg-${var.app_name}-${var.env}"
}


module "ad_app" {
  source                     = "../modules/ad-app"
  name                       = var.domain_name
  redirect_url               = "app.${var.domain_name}"
  include_localhost_redirect = true
  logo_b64                   = filebase64("${path.root}/../resources/ad_app.png")
  price_per_month = 0
}

locals {
  secrets = tomap({
    adapplicationsecret = module.ad_app.application_secret,
    publicvapidkey      = var.publicvapidkey
    privatevapidkey     = var.privatevapidkey,
    sendgridapikey      = var.sendgridapikey
  })
}

module "zone_westeurope" {
  source                   = "../modules/zone"
  location                 = "West Europe"
  resource_group           = module.rg.name
  app_name                 = var.app_name
  env                      = var.env
  secrets                  = local.secrets
  ad_application_id        = module.ad_app.application_id
  ad_application_secret    = module.ad_app.application_secret
  ad_audience              = module.ad_app.audience
  ad_issuer                = module.ad_app.issuer
  internal_role_id         = module.ad_app.internal_role_id
  ad_application_object_id = module.ad_app.sp_object_id
  domain_name              = var.app_hostname
  is_main                  = true
  signalr_capacity                = 1
  signalr_sku                     = "Free_F1"
  swa_sku_size                    = null
  swa_sku_tier                    = "Free"
  appi_retention                  = 30
  appi_sku                        = "PerGB2018"
  ai_sku                           = "F0"
}
