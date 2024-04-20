locals {
  vpc_name = "huy-stg-vpc"
  vpc_cidr = "10.0.0.0/24" # 256 hosts
  submet_mask = 28
  subnet_count = 3
  subnet_name = "huy-stg-subnet"
  subnets = [for i in range(local.subnet_count): {
    "cidr": "10.0.0.${(32 - local.submet_mask) * 4 * i}/${local.submet_mask}",
    "name": "huy-stg-subnet-${i+1}"
  }]
}

variable "sec_group_name" {
  default = "huy-stg-sgroups"
}

variable "sec_group_description" {
  default = "Test Security Group - allow All Trafic to My IP"
}

variable "ip_list" {
  description = "Allowed IPs"
  type = list(string)
  default = [
    "0.0.0.0/0",
  ]
}

variable "port_list" {
  description = "Allowed ports"
  type = list(number)
  default = [
    22,
    80,
    8080,
  ]
}