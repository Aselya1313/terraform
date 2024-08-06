data





data "aws_ami" "ami" {
    most_recent = true
    owners = [ "211125442217" ]

    filter {
      name = "name"
      tags = {

    }
}

# data "aws_ami" "example" {
#   most_recent = true

#   owners = ["self"]
#   tags = {
#     Name   = "app-server"
#     Tested = "true"
#   }
# }
