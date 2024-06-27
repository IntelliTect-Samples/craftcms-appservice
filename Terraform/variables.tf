
variable "project_name" {
  type        = string
  description = ""
  default     = ""
}

variable "environment_name" {
  type        = string
  description = ""
}

variable "region_name" {
  type = string

  default     = "westus2"
  description = "The Azure location for this resource to be created in."
}

variable "region_name_abbreviation" {
  type        = string
  description = "wus2"
}

variable "resource_suffix" {
  type = string

  description = ""
  default     = ""
}

variable "app_service_plan_os_type" {
  type = string

  default = "Linux"
}

variable "app_service_plan_sku_name" {
  type = string

  default = "S1"
}

variable "mysql_administrator_login" {
  type        = string
  description = "MySql Administrative Login"
  sensitive   = true
}

variable "mysql_administrator_password" {
  type        = string
  description = "MySql Administrative Password"
  sensitive   = true
}

variable "mysql_sku_name" {
  type = string

  default     = "GP_Standard_D2ads_v5"
  description = ""
}

variable "mysql_sku_version" {
  type = string

  default     = "8.0.21"
  description = ""
}

variable "mysql_user_assigned_identity_names" {
  type = list(string)

  default     = null
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this SQL Server."
}

variable "storage_account_replication_type" {
  type = string

  default     = "LRS"
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
}

variable "default_to_oauth_authentication" {
  type = bool

  default     = false
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is false"
}

variable "craft_cms_security_key" {
  type = string

  description = "A 32 bit encrytion key that CraftCMS will use internally for encrytion operations."
}

variable "craft_dev_mode" {

  type = bool

  default = false
  description = "Indicates if the web instance will be a Craft development instance or not."
}
