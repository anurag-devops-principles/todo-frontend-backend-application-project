address_space = ["192.168.100.0/24"]

subnet = {
  "fe_subnet" = {
    name            = "$${local.name_prefix}-fe-subnet"
    address_prfixes = ["192.168.100.0/26"]
  }
  "be_subnet" = {
    name            = "$${local.name_prefix}-be-subnet"
    address_prfixes = ["192.168.100.128/26"]
  }
}
