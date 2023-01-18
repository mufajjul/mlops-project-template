data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

locals {
  safe_prefix  = replace(var.prefix, "-", "")
  safe_postfix = replace(var.postfix, "-", "")
}

resource "azurerm_storage_account" "st" {
  name                     = "st${local.safe_prefix}${local.safe_postfix}${var.env}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = var.hns_enabled

  tags = var.tags
}

# Virtual Network & Firewall configuration

resource "azurerm_storage_account_network_rules" "firewall_rules" {
  storage_account_id = azurerm_storage_account.st.id

  default_action             = "Allow"
  ip_rules                   = [] # [data.http.ip.body]
  virtual_network_subnet_ids = var.firewall_virtual_network_subnet_ids
  bypass                     = var.firewall_bypass
}

# Data Lake Gen2 file system required for synapse workspace
resource "azurerm_storage_data_lake_gen2_filesystem" "st_filesystem" {
  name               = "dl${local.safe_prefix}${local.safe_postfix}${var.env}"
  storage_account_id = azurerm_storage_account.st.id

  count = var.enable_feature_store ? 1 : 0
}


# make the priviledged user a storage blob data contributor of the storage account
resource "azurerm_role_assignment" "priviledged_user_storage_contributor" {
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.priviledged_object_id

  count = var.enable_feature_store ? 1 : 0
}
