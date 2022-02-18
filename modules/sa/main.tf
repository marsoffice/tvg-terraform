terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier
  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
  }
}

# resource "azurerm_storage_table" "jobs" {
#   name                 = "Jobs"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }

# resource "azurerm_storage_table" "videos" {
#   name                 = "Videos"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }

# resource "azurerm_storage_table" "tta" {
#   name                 = "TikTokAccounts"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }

# resource "azurerm_storage_table" "usersettings" {
#   name                 = "UserSettings"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }

# resource "azurerm_storage_table" "usedposts" {
#   name                 = "UsedPosts"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }
# resource "azurerm_storage_table" "pushs" {
#   name                 = "PushSubscriptions"
#   storage_account_name  = azurerm_storage_account.storage_account.name
# }

resource "azurerm_storage_container" "jobsdatacontainer" {
  name                  = "jobsdata"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "editorcontainer" {
  name                  = "editor"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "audiocontainer" {
  name                  = "audio"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "videocontainer" {
  name                  = "video"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}