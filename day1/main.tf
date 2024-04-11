resource "aws_instance" "spring" {
  ami           = "ami-080e1f13689e07408"  # AMI Ubuntu
  instance_type = "t2.micro"
  associate_public_ip_address = true
}

resource "aws_instance" "summer" {
  ami           = "ami-051f8a213df8bc089"  # AMI Amazon Linux
  instance_type = "t3.micro"
}

resource "aws_instance" "winter" {
  ami           = "ami-080e1f13689e07408"  # AMI Ubuntu
  instance_type = "t2.micro"
  monitoring    = true
}