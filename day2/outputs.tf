output "instance_ips" {
  value = aws_instance.my_instance.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}  

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  description = "The subnet_ids of the subnet1 "
  value       = aws_subnet.my_subnet1.id
}

output "subnet_id" {
  description = "The subnet_ids of the subnet2 "
  value       = aws_subnet.my_subnet2.id
}

