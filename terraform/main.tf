resource "azurerm_resource_group" "resource_group" {
  name     = "${local.name_prefix}-rg"
  location = local.region

  tags = local.common_tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${local.name_prefix}-vnet"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = local.address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnet

  name                 = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-subnet"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = local.subnet[each.value.address_prefixes]
}

resource "azurerm_network_security_group" "security_group" {
  for_each = var.security_groups

  name                = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-nsg"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name

  dynamic "security_rule" {
    for_each = {
      for idx, port in sort(each.value.security_rule) : idx => port
    }
    content {
      name                       = "Allow-${security_rule.value}"
      priority                   = 100 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = var.subnet_nsg_association

  subnet_id                 = azurerm_subnet.subnet[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.security_group[each.value.nsg_key].id
}

resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ip

  name                = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-pip"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = local.allocation_method

  tags = local.common_tags
}

resource "azurerm_network_interface" "network_interface" {
  for_each = var.network_interface

  name                = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-nic"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet[each.value.subnet_key].id
    private_ip_address_allocation = local.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip[each.value.public_ip_key].id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  for_each = var.virtual_machine

  name                            = "${replace(each.value.name, "$${local.name_prefix}", local.name_prefix)}-vm"
  location                        = local.region
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = local.vm_module.size
  admin_username                  = local.vm_module.admin_username
  admin_password                  = local.vm_module.admin_password
  disable_password_authentication = local.vm_module.disable_password_authentication
  custom_data                     = local.vm_module.custom_data[each.key]
  network_interface_ids           = [azurerm_network_interface.network_interface[each.value.nic_key].id]

  os_disk {
    caching              = local.vm_module.caching
    storage_account_type = local.vm_module.storage_account_type
  }
  source_image_reference {
    publisher = local.vm_module.publisher
    offer     = local.vm_module.offer[each.key]
    sku       = local.vm_module.sku[each.key]
    version   = local.vm_module.version
  }

  tags = local.common_tags
}
