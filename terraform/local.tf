locals {
  environment   = "dev"
  application   = "todo"
  owner         = "devops-team"
  project       = "devops-practice"
  region        = "central india"
  address_space = ["192.168.100.0/24"]
  subnet = {
    fe-address-prefix = ["192.168.100.0/26"]
    be-address-prefix = ["192.168.100.128/26"]
  }
  allocation_method             = "Static"
  private_ip_address_allocation = "Dynamic"
  vm_module = {
    size                            = "Standard_B2s"
    admin_username                  = "adminuser"
    admin_password                  = "Adminuser@1234"
    disable_password_authentication = false
    custom_data = {
      fe-vm = base64encode(file("nginx.sh"))
      be-vm = base64encode(file("python.sh"))
    }
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    publisher            = "Cannonical"
    offer = {
      fe-vm = "0001-com-ubuntu-server-jammy"
      be-vm = "0001-com-ubuntu-server-focal"
    }
    sku = {
      fe-vm = "22_04-LTS"
      be-vm = "20_04-LTS"
    }
    version = "latest"
  }
}

locals {
  name_prefix = "${local.environment}-${local.application}"
}

locals {
  common_tags = {
    "environment" = local.environment
    "owner"       = local.owner
    "project"     = local.project
    "application" = local.application
  }
}
