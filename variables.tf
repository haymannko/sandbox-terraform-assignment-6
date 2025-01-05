variable "peering_vpc1" {
    type = object({
      Name = string
      cidr = string
    })
      default = {
        Name = "peering_vpc_1"
        cidr = "10.0.0.0/16"
      }
  
}


variable "peering_vpc2" {
    type = object({
      Name = string
      cidr = string
    })
      default = {
        Name = "peering_vpc_2"
        cidr = "192.168.0.0/16"
      }
  
}


variable "cidr_for_public_subnet" {
  default = "10.0.1.0/24"

}

variable "name_for_public_subnet" {
    default = "public_subnet_1"
}

variable "cidr_for_private_subnet" {
  default = "192.168.1.0/24"

}

variable "name_for_private_subnet" {
    default = "private_subnet_1"
}