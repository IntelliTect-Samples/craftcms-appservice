
resource "azurerm_linux_web_app" "app" {
  name                = "app-${local.name}"
  location            = local.region
  resource_group_name = local.resource_group_name

  identity {
    identity_ids = [azurerm_user_assigned_identity.main.id]
    type         = "UserAssigned"
  }

#   key_vault_reference_identity_id          = azurerm_user_assigned_identity.main.id
  service_plan_id                          = azurerm_service_plan.app.id
  ftp_publish_basic_authentication_enabled = false
  https_only                               = true
  virtual_network_subnet_id                = resource.azurerm_subnet.default.id

  app_settings = {
    "CRAFT_DEV_MODE"                      = var.craft_dev_mode
    "CRAFT_APP_ID"                        = "craftcms_${local.environment}"
    "CRAFT_DB_CHARSET"                    = "utf8mb4"
    "CRAFT_DB_COLLATION"                  = "utf8mb4_general_ci"
    "CRAFT_DB_DATABASE"                   = "craftcms"
    "CRAFT_DB_DRIVER"                     = "mysql"
    "CRAFT_DB_PORT"                       = "3306"
    "CRAFT_DB_SCHEMA"                     = ""
    "CRAFT_DB_SERVER"                     = "${resource.azurerm_mysql_flexible_server.main.name}.mysql.database.azure.com"
    "CRAFT_DB_TABLE_PREFIX"               = ""
    "CRAFT_DB_USER"                       = var.mysql_administrator_login
    "CRAFT_DB_USER_PASSWORD"              = var.mysql_administrator_password
    "CRAFT_ENVIRONMENT"                   = local.environment
    "CRAFT_SECURITY_KEY"                  = var.craft_cms_security_key
    "PRIMARY_SITE_URL"                    = "app-${local.project}-${local.environment}-${local.location}.azurewebsites.net"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_PORT"                       = "8080"
  }

  # by not configuring logs in Terraform here and ignoring changes regarding logs, 
  # log configuration will be done manually in the portal per environment.
  logs {}

  site_config {
    app_command_line                              = ""
    container_registry_use_managed_identity       = false
    use_32_bit_worker                             = false
    vnet_route_all_enabled                        = true
    websockets_enabled                            = false
    ftps_state                                    = "FtpsOnly"
    # container_registry_managed_identity_client_id = azurerm_user_assigned_identity.main.client_id


    application_stack {
      docker_registry_url = "https://${resource.azurerm_container_registry.main.name}.azurecr.io"
      docker_image_name   = "craftcms:latest"
    }
  }

  lifecycle {
    ignore_changes = [
      logs[0].http_logs[0].azure_blob_storage[0].sas_url,
      logs[0].application_logs[0].azure_blob_storage[0].sas_url,
      site_config[0].ip_restriction_default_action,
      site_config[0].scm_ip_restriction_default_action,
      logs
    ]
  }
}

