locals {

  app_log_container_name = "${local.environment}-app-log"
  web_log_container_name = "${local.environment}-web-log"

  storage_containers = tolist([
    {
      name                  = "files"
      container_access_type = "private"
    }
  ])
  storage_shares    = []
  share_directories = []
}


resource "azurerm_storage_account" "main" {
  name                     = "sa${local.name_nodash}web"
  resource_group_name      = local.resource_group_name
  location                 = local.region
  min_tls_version          = "TLS1_2"
  account_tier             = "Standard"
  account_replication_type = var.storage_account_replication_type

  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = var.default_to_oauth_authentication
  allow_nested_items_to_be_public  = false

  is_hns_enabled = true
  nfsv3_enabled  = true
  sftp_enabled   = true

  network_rules {
    ## Must be deny for NFS enabled Storage Accounts
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = ["0.0.0.0/0"]

    # private_link_access {
    #   endpoint_resource_id = "/subscriptions/5f02b8ba-4f12-4c7d-ac1a-c7ab2689393b/providers/Microsoft.Security/datascanners/storageDataScanner"
    #   endpoint_tenant_id   = "0b9b5fcf-b10f-4b34-9668-4b70f926297a"
    # }
  }

  lifecycle {
    ignore_changes = [ 
      network_rules[0].private_link_access
     ]
  }
}


resource "azurerm_storage_container" "main" {
  for_each = { for index, container in local.storage_containers == null ? [] : local.storage_containers : container.name => container }

  name                  = lower("${each.value.name}")
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.container_access_type
}


resource "azurerm_storage_share" "main" {
  for_each = { for index, share in local.storage_shares == null ? [] : local.storage_shares : share.name => share }

  name                 = lower("${each.value.name}")
  storage_account_name = azurerm_storage_account.main.name
  quota                = each.value.quota

  dynamic "acl" {
    for_each = each.value.acls

    content {
      id = acl.value.id

      dynamic "access_policy" {
        for_each = acl.value.access_policy == null ? [] : [acl.value.access_policy]

        content {
          permissions = access_policy.value.permissions
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
        }
      }

    }
  }
}

resource "azurerm_storage_share_directory" "shares" {
  for_each = { for index, share_directory in local.share_directories : share_directory.key => share_directory }

  name             = each.value.directory_name
  storage_share_id = azurerm_storage_account.main[each.value.key].id

  depends_on = [azurerm_storage_share.main]
}

