provider "azurerm" {
  features {}
}

#Azure Generic vNet Module
data "azurerm_resource_group" "network" {
  name = var.resource_group_name
}

locals {
  virtual_network_name = var.vnet_name == "" ? azurerm_virtual_network.vnet.0.name : var.vnet_name
}

data "azurerm_virtual_network" "default" {
  name                = local.virtual_network_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.vnet_name == "" ? 1 : 0
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.network.name
  location            = data.azurerm_resource_group.network.location
  address_space       = length(var.address_spaces) == 0 ? [var.address_space] : var.address_spaces
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnet_names)
  name                                           = var.subnet_names[count.index]
  resource_group_name                            = data.azurerm_resource_group.network.name
  address_prefixes                               = [var.subnet_prefixes[count.index]]
  virtual_network_name                           = local.virtual_network_name
  enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, var.subnet_names[count.index], false)
  service_endpoints                              = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], [])
}
