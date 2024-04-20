resource "aws_vpc" "vpc_main" {
  cidr_block       = "10.0.0.0/24"  # 256 hosts 
  instance_tenancy = "default"

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "subnets" {
  vpc_id     = aws_vpc.vpc_main.id
  for_each = { for idx, subnet in local.subnets : subnet.name => subnet }

  cidr_block = each.value.cidr
  
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "igw_test" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-test-by-Huy"
  }
}

resource "aws_route_table" "route_table_pri_test" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = aws_vpc.vpc_main.cidr_block
    gateway_id = "local"
  }
}

resource "aws_route_table" "route_table_public_test" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_test.id
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  subnet_id      = aws_subnet.subnets["huy-stg-subnet-1"].id # only first subnet is public
  route_table_id = aws_route_table.route_table_public_test.id
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.vpc_main.id
  description = var.sec_group_description
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description = ""
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    },
  ]
  ingress = [
    for _port in var.port_list:
    {
      cidr_blocks = [
      for _ip in var.ip_list:
      _ip
      ]
      description = ""
      from_port = _port
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = _port
    }
  ]
  name = var.sec_group_name
} 

output created_subnets {
  value = aws_subnet.subnets
}

output created_vpc {
  value = aws_vpc.vpc_main
}

output created_security_group {
  value = aws_security_group.instance
}