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

output "subnet_config" {
    value = local.subnets
}