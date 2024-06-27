
resource "azurerm_user_assigned_identity" "main" {
  name                = "id-${local.name}"
  location            = local.region
  resource_group_name = local.resource_group_name
}

