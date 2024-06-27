
resource "azurerm_resource_group" "application_resource_group" {
  # name     = "rg-${local.name}"
  name     = "${local.resource_group_name_prefix}-${local.environment}"
  location = local.region

  tags = {
    "Environment"  = "${title(local.environment)}"
    "KTI Networks" = "Owner"
  }
}


# # KTEA-Marketing-KTIWebsite-dev
# data "azurerm_resource_group" "application_resource_group" {
#   name = "KTEA-Marketing-KTIWebsite-${local.environment}"
# }
