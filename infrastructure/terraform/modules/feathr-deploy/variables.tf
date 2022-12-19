variable "location" {
  type        = string
  description = "Location used for all resources"
}

variable "resource_group" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "enable_feathr_deployment" {
  description = "Variable to enable or disable Feathr Deployment"
}