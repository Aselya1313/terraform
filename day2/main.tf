resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "dev"
  }
}

resource "aws_instance" "my_instance" {
  subnet_id = aws_subnet.my_subnet2.id
  ami           = "ami-051f8a213df8bc089"  # AMI Amazon Linux
  instance_type = "t2.micro"
  
}








