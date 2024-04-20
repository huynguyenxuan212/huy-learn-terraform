
provider "aws" {
  region  = "ap-southeast-1"
  profile = "pixta-dev"
}

resource "aws_key_pair" "huy_keypair" {
  key_name   = "nguyenxuanhuy@Pixtas-MacBook-Pro-4.local"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key file
}

resource "aws_instance" "ec2_instances" {
  count         = 3  
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = ["sg-0745a7fef73e3a95f", "sg-0f8004ddedf46bcfb"]
  subnet_id              = "subnet-e9fc918d"

  key_name = aws_key_pair.huy_keypair.key_name  

  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
}
