data "aws_subnet" "default_subnet" {
    filter {
      name = "tag:Name" 
      values = {"Aiymdar"}
    }   
}

data "aws_ami" "ami" {
    most_recent = true
    owners = [ "211125442217" ]

    filter {
      name = "name"
      tags = {
resource "aws_instance" "instance" {
    ami = ""
    instance_type = t3.micro
    subnet_id = data.aws_subnet.default_subnet.id
}

