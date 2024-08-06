resource "aws_s3_bucket" "bucket" {
  bucket = "aiymdar.tfstate"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
terraform {
  backend "s3" {
    region            = "us-east-1"
    bucket            = "aiymdar.tfstate"
    key               = "dev/terraform.tfstate"
    dynamodb_endpoint = "terraform-state-lock-dynamo"
    encrypt           = true
    kms_key_id        = "alias/kms"
  }
}
locals {
  vpc_id = aws_vpc.vpc.id
  name   = "local"
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "${local.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = local.vpc_id

  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-public_subnet"
    #   env = "dev"
    # }
    # lifecycle {
    #     ignore_changes = {cidr_block}

  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    "Name" = "${local.name}-igw"
  }

}

resource "aws_route_table" "rtb-public" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.rtb-public.id
  subnet_id      = aws_subnet.public_subnet.id

}
resource "aws_subnet" "private_subnet" {
  vpc_id = local.vpc_id

  cidr_block = "10.0.2.0/24"

  tags = {
    "Name" = "${local.name}-private_subnet"
  }

}


