locals {
    instance_name = ["first", "second"]

}

resource "aws_instance" "instance" {
    count = length(local.instance_name)
    ami = data.aws_ami.ami.id
    instance_type = "t3.micro"

    tags = {
        "Name" = "instance-${count.index}"
    } 
}

