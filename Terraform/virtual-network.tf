
locals {
  vnet_newbits = 8
  vnet_netnum  = 0
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.name}"
  resource_group_name = local.resource_group_name
  location            = local.region
  address_space       = [local.vnet_address_cidr]

# flow_timeout_in_minutes = 0

}


resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(local.vnet_address_cidr, local.vnet_newbits, local.vnet_netnum)]


  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Web",
  ]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }

}

