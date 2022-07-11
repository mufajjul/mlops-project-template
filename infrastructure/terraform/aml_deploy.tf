# Resource group

module "resource_group" {
  source = "./modules/resource-group"

  location = var.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  tags = local.tags
}

# Azure Machine Learning workspace

module "aml_workspace" {
  source = "./modules/aml-workspace"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  storage_account_id      = module.storage_account_aml.id
  key_vault_id            = module.key_vault.id
  application_insights_id = module.application_insights.id
  container_registry_id   = module.container_registry.id

  enable_aml_computecluster = var.enable_aml_computecluster
  storage_account_name      = module.storage_account_aml.name

  enable_aml_secure_workspace = var.enable_aml_secure_workspace
  vnet_id                     = azurerm_virtual_network.vnet_default.id
  subnet_default_id           = azurerm_subnet.snet_default.id
  subnet_training_id          = azurerm_subnet.snet_training.id

  tags = local.tags
}

# Storage account

module "storage_account_aml" {
  source = "./modules/storage-account"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  hns_enabled                         = false
  firewall_bypass                     = ["AzureServices"]
  firewall_virtual_network_subnet_ids = []

  enable_aml_secure_workspace = var.enable_aml_secure_workspace
  vnet_id                     = azurerm_virtual_network.vnet_default.id
  subnet_id                   = azurerm_subnet.snet_default.id

  tags = local.tags
}

# Key vault

module "key_vault" {
  source = "./modules/key-vault"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  enable_aml_secure_workspace = var.enable_aml_secure_workspace
  vnet_id                     = azurerm_virtual_network.vnet_default.id
  subnet_id                   = azurerm_subnet.snet_default.id

  tags = local.tags
}

# Application insights

module "application_insights" {
  source = "./modules/application-insights"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  tags = local.tags
}

# Container registry

module "container_registry" {
  source = "./modules/container-registry"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  enable_aml_secure_workspace = var.enable_aml_secure_workspace
  vnet_id                     = azurerm_virtual_network.vnet_default.id
  subnet_id                   = azurerm_subnet.snet_default.id

  tags = local.tags
}