variable "subscription_id" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnet" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}
