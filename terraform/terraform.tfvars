subnet = {
  "fe-subnet" = {
    name             = "$${local.name_prefix}-fe"
    address_prefixes = "fe-address-prefix"
  }
  "be-subnet" = {
    name             = "$${local.name_prefix}-be"
    address_prefixes = "be-address-prefix"
  }
}

security_groups = {
  "fe-nsg" = {
    name          = "$${local.name_prefix}-fe"
    security_rule = [22, 80]
  }
  "be-nsg" = {
    name          = "$${local.name_prefix}-be"
    security_rule = [22, 8000]
  }
}

subnet_nsg_association = {
  "fe-subnet-nsg" = {
    subnet_key = "fe-subnet"
    nsg_key    = "fe-nsg"
  }
  "be-subnet-nsg" = {
    subnet_key = "be-subnet"
    nsg_key    = "be-nsg"
  }
}

public_ip = {
  "fe-pip" = {
    name = "$${local.name_prefix}-fe"
  }
  "be-pip" = {
    name = "$${local.name_prefix}-be"
  }
}

network_interface = {
  "fe-nic" = {
    name          = "$${local.name_prefix}-fe"
    subnet_key    = "fe-subnet"
    public_ip_key = "fe-pip"
  }
  "be-nic" = {
    name          = "$${local.name_prefix}-be"
    subnet_key    = "be-subnet"
    public_ip_key = "be-pip"
  }
}

virtual_machine = {
  "fe-vm" = {
    name    = "$${local.name_prefix}-fe"
    nic_key = "fe-nic"
  }
  "be-vm" = {
    name    = "$${local.name_prefix}-be"
    nic_key = "be-nic"
  }
}
