output "instance_ids" {
  description = "ID of the EC2 instances"
  value = {
    for key, instance in aws_instance.ec2_instances : key => instance.id
  }

}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instances"
  value = {
    for key, instance in aws_instance.ec2_instances : key => instance.public_ip
  }
}
