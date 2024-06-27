

resource "azurerm_service_plan" "app" {
  name                = "asp-${local.name}"
  resource_group_name = local.resource_group_name
  location            = local.region
  
  sku_name            = var.app_service_plan_sku_name
  os_type             = var.app_service_plan_os_type 
}




