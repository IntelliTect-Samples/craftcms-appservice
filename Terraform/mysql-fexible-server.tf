
locals {
  configurations = [
    {
      name  = "require_secure_transport"
      value = "OFF"
    }
  ]

  firewall_rules = flatten(
    [for network in local.network_whitelist :
      {
        name             = network.name,
        start_ip_address = network.ip_address,
        end_ip_address   = network.ip_address
      }
    ]
  )

  databases = [
    {
    name      = "craftcms"
    charset   = "utf8mb4"
    collation = "utf8mb4_0900_ai_ci" #"utf8mb4_general_ci"
  }
  ]
}

# NOTE: Azure Database for "MySQL - Single Server (azurerm_mysql_server)" is scheduled for retirement by September 16, 2024 in leu of MySQL Flexible Server (azurerm_mysql_flexible_server). 

resource "azurerm_mysql_flexible_server" "main" {
  name                = "mysql-${local.name}"
  resource_group_name = local.resource_group_name
  location            = local.region

  administrator_login    = var.mysql_administrator_login
  administrator_password = var.mysql_administrator_password
  backup_retention_days  = 7
#   delegated_subnet_id          = ???
  geo_redundant_backup_enabled = false
  sku_name                     = var.mysql_sku_name
  version                      = var.mysql_sku_version

  tags = {}

  storage {
    # iops               = 1000
    size_gb            = 64
    auto_grow_enabled  = true
    io_scaling_enabled = true
  }

  identity {
    identity_ids = [azurerm_user_assigned_identity.main.id]
    type         = "UserAssigned"
  }

  lifecycle {
	ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]	
  }		  

}



resource "azurerm_mysql_flexible_server_configuration" "main" {
  for_each = { for c in local.configurations : c.name => c }

  name                = each.value.name
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  value               = each.value.value

  depends_on = [
    azurerm_mysql_flexible_server.main
  ]
}


resource "azurerm_mysql_flexible_server_firewall_rule" "main" {
  for_each = { for r in local.firewall_rules : r.name => r }

  name                = each.value.name
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address

  depends_on = [
    azurerm_mysql_flexible_server.main
  ]
}

# resource "azurerm_mysql_virtual_network_rule" "main" {
#   for_each = { for nr in var.network_rules : nr.name => nr }

#   name                = "msvr-${each.value.name}"
#   resource_group_name = local.resource_group_name
#   server_name         = azurerm_mysql_flexible_server.main.name
#   subnet_id           = "${each.value.subnet_id}"

#   depends_on = [
#     azurerm_mysql_flexible_server.main
#   ]
# }

resource "azurerm_mysql_flexible_database" "main" {
  for_each = { for db in local.databases : db.name => db }

  name                = "${each.value.name}"
  server_name         = azurerm_mysql_flexible_server.main.name
  resource_group_name = local.resource_group_name
  collation           = each.value.collation
  charset             = each.value.charset

  depends_on = [
    azurerm_mysql_flexible_server.main
  ]
}




