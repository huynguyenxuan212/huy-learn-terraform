
module "networking" {
  source        = "../networking"
}

data "aws_instances" "existed_by_Huy_instances" {
  filter {
    name   = "tag:Name"
    values = ["${substr(var.instance_pattern, 0, 24)}*"]  # pattern name*
  }
}


import {
  for_each = toset(data.aws_instances.existed_by_Huy_instances.ids)
  id = each.key
  to = aws_instance.exist_ec2_instances[each.key]
}

resource "aws_instance" "exist_ec2_instances" {
  for_each = toset(data.aws_instances.existed_by_Huy_instances.ids)
  vpc_security_group_ids = [module.networking.created_security_group.id]
  subnet_id              = module.networking.created_subnets["huy-stg-subnet-${index(data.aws_instances.existed_by_Huy_instances.ids, tostring(each.value)) + 1}"].id
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.micro"
}


# output "aws_instances_modified" {
#   value = {
#     for i_id in toset(data.aws_instances.existed_by_Huy_instances.ids) : i_id => lookup(module.networking.created_subnets, "huy-stg-subnet-${index(data.aws_instances.existed_by_Huy_instances.ids, tostring(i_id)) + 1}").id
#   }
# }

output "aws_instances_modified" {
  value = {
    for idx, instance in aws_instance.exist_ec2_instances : idx => instance.subnet_id
  }
}