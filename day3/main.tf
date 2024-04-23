resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "asel"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  depends_on = [aws_vpc.my_vpc]

  tags = {
    Name = "asel"
  }
}

resource "aws_subnet" "my_private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  depends_on = [aws_vpc.my_vpc]
  tags = {
    Name = "private"
  }
}

resource "aws_instance" "my_instance1" {
  ami           = "ami-0663b059c6536cac8"  # AMI Amazon Linux
  instance_type = "t2.micro"
  provider      = aws.origon
  tags = {
    Name = "Dev"
  }
}
# Создание интернет-шлюза
resource "aws_internet_gateway" "internet" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Main Internet Gateway"
  }
}


# # Присоединение интернет-шлюза к VPC
# resource "aws_vpc_attachment" "main_attachment" {
#   vpc_id       = aws_vpc.my_vpc.id
#   internet_gateway_id = aws_internet_gateway.internet.id
# }

# Создание маршрутной таблицы для публичной подсети
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet.id
  }
}

# Привязка маршрутной таблицы к публичной подсети
resource "aws_route_table_association" "my_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Создание правил безопасности для публичной подсети
resource "aws_security_group" "SG" {
  name        = "SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "HTTPS" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4       = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4       = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4       = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_instance" "my_instance" {
  subnet_id = aws_subnet.my_subnet.id
  ami           = "ami-051f8a213df8bc089"  # AMI Amazon Linux
  instance_type = "t2.micro"
  depends_on = [aws_subnet.my_subnet]
  security_groups = [ aws_security_group.SG.id ]
  tags = {
    Name = "asel"
  }
}


resource "aws_instance" "my_private_instance" {
  subnet_id = aws_subnet.my_private_subnet.id
  ami           = "ami-051f8a213df8bc089"  # AMI Amazon Linux
  instance_type = "t2.micro"
  depends_on = [aws_subnet.my_private_subnet]
  tags = {
    Name = "private"
  }
}

# Создание маршрутной таблицы для приватной подсети
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}
# Создание Elastic IP
resource "aws_eip" "eip" {
  vpc = true
}

# Создание NAT-шлюза
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "NAT"
  }
}

 
# Привязка маршрутной таблицы к приватной подсети
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.my_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}






