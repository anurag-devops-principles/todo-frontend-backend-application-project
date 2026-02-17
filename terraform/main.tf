resource "azurerm_resource_group" "resource_group" {
  name     = "${local.name_prefix}-rg"
  location = local.location

  tags = local.common_tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${local.name_prefix}-vnet"
  location            = local.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = replace(each.value.name, "$${local.name_prefix}", local.name_prefix)
  virtual_network_name = azurerm_virtual_network_virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = each.value.address_prefixes
}

# resource "azurem_network_security_group" "network_security" {
#     for_each = var.network_security_group
#     name = each.value.name
#     location = local.location
#     resource_group_name = azurerm_resource_group.resource_group.name
# }
