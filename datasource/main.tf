provider "aws" {
  region  = "ap-southeast-1"
  profile = "pixta-dev"
}

data "aws_instances" "existed_by_Huy_instances" {
  filter {
    name   = "tag:Name"
    values = ["${substr(var.instance_pattern, 0, 24)}*"]  # pattern name*
  }
}

data "aws_instance" "instance_details" {
  for_each = toset(data.aws_instances.existed_by_Huy_instances.ids)

  instance_id = each.key
  
  depends_on = [
    data.aws_instances.existed_by_Huy_instances
  ]
}

output "instance_info" {
  value = {
    for idx, instance_id in data.aws_instances.existed_by_Huy_instances.ids : instance_id => data.aws_instance.instance_details[instance_id]
  }
}

# output "instances_info" {
#   value = data.aws_instances.existed_by_Huy_instances.ids
# }
