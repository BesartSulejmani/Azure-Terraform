variable "prefix" {
  type    = string
  description = "Prefix differentiator"
}

variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "westeurope"
}

variable "tags" {
  type = map

  default = {
    Environment = "Terraform GS"
    Dept        = "Engineering"
  }
}

variable "sku" {
  default = {
    westeurope = "16.04-LTS"
    easteurope  = "18.04-LTS"
    }
}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}