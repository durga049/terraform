provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"

}

resource "aws_vpc" "jio_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.jio_vpc.id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.1.2.0/24"
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.jio_vpc.id
  availability_zone = "ap-south-1b"
  cidr_block        = "10.1.3.0/24"
}

resource "aws_internet_gateway" "jio_internet" {
  vpc_id = aws_vpc.jio_vpc.id
}

# Ensure only the default route table is returned for the VPC
data "aws_route_table" "default" {
  vpc_id = aws_vpc.jio_vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
  # Optionally, you can add further filters or constraints here if needed, 
  # like `main = true` to specifically target the main route table
}

resource "aws_route" "jio_route" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jio_internet.id
}

resource "aws_eip" "ji0_nat" {
  vpc = true
}

resource "aws_nat_gateway" "name" {
  subnet_id         = aws_subnet.public.id
  connectivity_type = "public"
  allocation_id     = aws_eip.ji0_nat.id
}

resource "aws_route_table" "jio_private_route" {
  vpc_id = aws_vpc.jio_vpc.id
}

resource "aws_route_table_association" "table_assign" {
  route_table_id = aws_route_table.jio_private_route.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.jio_private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.name.id
}

resource "aws_security_group" "jio_security" {
  vpc_id = aws_vpc.jio_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "public_instaance" {
  ami                         = "ami-00bb6a80f01f03502"
  instance_type               = "t2.micro"
  key_name                    = "aws_key"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.jio_security.id]

}

resource "aws_instance" "private_instance" {
  ami = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  key_name = "aws_key"
  subnet_id = aws_subnet.private.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.jio_security.id]
  
}


output "ec2_id" {
  value = aws_instance.public_instaance.public_ip
  
}

