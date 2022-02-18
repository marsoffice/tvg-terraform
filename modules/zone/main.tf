terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


module "appi" {
  source         = "../appi"
  location       = var.location
  name           = "appi-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  resource_group = var.resource_group
  retention      = var.appi_retention
  sku            = var.appi_sku
}

module "sa" {
  source           = "../sa"
  location         = var.location
  resource_group   = var.resource_group
  name             = "sa${var.app_name}${replace(lower(var.location), " ", "")}${var.env}"
  tier             = "Standard"
  replication_type = "LRS"
  access_tier      = "Hot"
}

module "signalr" {
  source          = "../signalr"
  location        = var.location
  resource_group  = var.resource_group
  name            = "signalr-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku             = var.signalr_sku
  capacity        = var.signalr_capacity
  allow_localhost = true
  allowed_host    = "https://${var.domain_name}"
}

module "translate" {
  source = "../ai"
  location = var.location
  resource_group = var.resource_group
  name = "ai-${var.app_name}-translate-${replace(lower(var.location), " ", "")}-${var.env}"
  sku = var.translator_sku
  kind = "TextTranslation"
}

module "speech" {
  source = "../ai"
  location = var.location
  resource_group = var.resource_group
  name = "ai-${var.app_name}-tts-${replace(lower(var.location), " ", "")}-${var.env}"
  sku = var.speech_sku
  kind = "SpeechServices"
}

module "kvl" {
  source         = "../kvl"
  location       = var.location
  resource_group = var.resource_group
  name           = "kvl-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  secrets = merge(var.secrets, tomap({
    signalrconnectionstring      = module.signalr.connection_string,
    localsaconnectionstring      = module.sa.connection_string,
    aiendpoint = module.translate.endpoint,
    aikey = module.translate.key,
    speechendpoint = module.speech.endpoint,
    speechkey = module.speech.key
  }))
}

module "appsp" {
  source         = "../appsp"
  location       = var.location
  resource_group = var.resource_group
  name           = "appsp-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

locals {
  commonsettings = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/${x}/)"]),
    tomap({
      ismain                       = var.is_main,
      location                     = var.location,
      localsaconnectionstring      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/localsaconnectionstring/)",
      scope                        = "${var.ad_audience}/.default",
      signalrconnectionstring      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/signalrconnectionstring/)",
      aiendpoint      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/aiendpoint/)",
      aikey      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/aikey/)",
      speechendpoint      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/speechendpoint/)",
      speechkey      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/speechkey/)",
      ffmpegpath = "/home/site/wwwroot/libs/ffmpeg_linux",
      ffprobepath = "/home/site/wwwroot/libs/ffprobe_linux"
    })
  )


}

module "func_notifications" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-notifications-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs                = local.commonsettings
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}


module "func_users" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-users-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs                = local.commonsettings
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_content" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-content-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_translate" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-translate-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_speech" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-speech-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}


module "func_videodownloader" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-videodownloader-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}


module "func_audiodownloader" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-audiodownloader-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_editor" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-editor-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_tiktok" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-tiktok-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
    
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}



module "func_jobs" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-jobs-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}


module "func_videos" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-videos-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(local.commonsettings, tomap({
    jobs_url = "https://${module.func_jobs.hostname}"
  }))
  ad_audience                = var.ad_audience
  ad_application_id          = var.ad_application_id
  ad_application_secret      = var.ad_application_secret
  ad_issuer                  = var.ad_issuer
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id         = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}



module "swa" {
  source         = "../swa"
  location       = var.location
  resource_group = var.resource_group
  name           = "swa-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku_size       = var.swa_sku_size
  sku_tier       = var.swa_sku_tier

  properties = tomap({
    users_url        = "https://${module.func_users.hostname}",
    notifications_url = "https://${module.func_notifications.hostname}",
    speech_url = "https://${module.func_speech.hostname}",
    jobs_url = "https://${module.func_jobs.hostname}",
    videos_url = "https://${module.func_videos.hostname}",
    content_url = "https://${module.func_content.hostname}",
    editor_url = "https://${module.func_editor.hostname}",
    translate_url = "https://${module.func_translate.hostname}",
    tiktok_url = "https://${module.func_tiktok.hostname}",
    videodownloader_url = "https://${module.func_videodownloader.hostname}",
    audiodownloader_url = "https://${module.func_audiodownloader.hostname}"
  })
}

module "swa_landing" {
  source         = "../swa"
  location       = var.location
  resource_group = var.resource_group
  name           = "swa-${var.app_name}-landing-${replace(lower(var.location), " ", "")}-${var.env}"
  sku_size       = var.swa_sku_size
  sku_tier       = var.swa_sku_tier

  properties = null
}