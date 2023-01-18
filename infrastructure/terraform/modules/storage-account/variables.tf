variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the Resource Group"
}

variable "prefix" {
  type        = string
  description = "Prefix for the module name"
}

variable "postfix" {
  type        = string
  description = "Postfix for the module name"
}

variable "env" {
  type        = string
  description = "Environment prefix"
}

variable "hns_enabled" {
  type        = bool
  description = "Hierarchical namespaces enabled/disabled"
  default     = true
}

variable "firewall_virtual_network_subnet_ids" {
  default = []
}

variable "firewall_bypass" {
  default = ["None"]
}
variable "enable_feature_store" {
  type        = bool
  default     = false
  description = "flag to enable or disable feature store"
}

variable "priviledged_object_id" {
  type        = string
  default     = ""
  description = "Object ID of the user or service principal that will ge granted priviledges in keyvault for feature store"
}
