
locals {
  project     = var.project_name
  environment = var.environment_name
  location    = var.region_name_abbreviation
  suffix      = var.resource_suffix
  region      = var.region_name

  name        = trim(join("", [local.project, "-", local.environment, "-", local.location, "-", local.suffix]), "-")
  name_nodash = replace(local.name, "-", "")

  resource_group_name_prefix = "KTEA-Marketing-KTIWebsite"
  resource_group_name        = azurerm_resource_group.application_resource_group.name

  app_domain                     = "ktea.com"
  vnet_address_cidr              = "10.0.0.0/16"
  vnet_address_cidr_range        = "10.0.0.0/16"
  storage_account_sas_starttime  = timestamp() # "2024-01-01T00:00:00Z"
  storage_account_sas_expirytime = "2099-12-31T00:00:00Z"

  network_whitelist = [
    {
      name       = "office_ip"
      ip_address = "50.212.205.194"
    },
    {
      name       = "home_ip"
      ip_address = "73.193.35.75"
    },
    {
      name       = "allow_access_to_azure_services"
      ip_address = "0.0.0.0"
    }
  ]
}
