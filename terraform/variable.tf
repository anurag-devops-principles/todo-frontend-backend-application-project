variable "subscription_id" {
  type    = string
  default = "bd7b142b-030a-46e3-8a31-579ffb9d2046"
}

variable "subnet" {
  type = map(object({
    name             = string
    address_prefixes = string
  }))
}

variable "security_groups" {
  type = map(object({
    name          = string
    security_rule = list(number)
  }))
}

variable "subnet_nsg_association" {
  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
}

variable "public_ip" {
  type = map(object({
    name = string
  }))
}

variable "network_interface" {
  type = map(object({
    name          = string
    subnet_key    = string
    public_ip_key = string
  }))
}

variable "virtual_machine" {
  type = map(object({
    name    = string
    nic_key = string
  }))
}
