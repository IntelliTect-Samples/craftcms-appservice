
resource "azurerm_container_registry" "main" {
  name                = "cr${local.name_nodash}"
  location            = local.region
  resource_group_name = local.resource_group_name

  sku           = "Standard" # one of ["Basic" "Standard" "Premium"]
  admin_enabled = true

  identity {
    identity_ids = [azurerm_user_assigned_identity.main.id]
    type         = "UserAssigned"
  }
}
