
data "azuread_client_config" "current" {
}

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}



data "azurerm_storage_account_sas" "sa_sas" {
  # data.azurerm_storage_account_sas.sa_sas
  connection_string = azurerm_storage_account.main.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"
  resource_types {
    service   = true
    container = true
    object    = false
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  start  = local.storage_account_sas_starttime
  expiry = local.storage_account_sas_expirytime
  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = false
    tag     = false
    filter  = false
  }
}













