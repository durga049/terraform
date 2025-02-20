provider "aws" {
  access_key = ""
  secret_key = ""
  region     = var.aws_region

}

resource "aws_instance" "public_instance" {
  count = (var.aws_region == "ap-south-1" ? 2 : 1)
  ami                         = lookup(var.ami, var.aws_region, "ap-south")
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-06fc524fec73a136d"
  availability_zone           = "ap-south-1a"
  key_name                    = "aws_key"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-05e0f13e2a0980f5b"]
  tags = {
    eniv = "var.eniv"
  }

}

#variable file 

variable "ami" {
  default = {
    "ap-south-1" = "ami-00bb6a80f01f03502"
    "us-east-1"  = "ami-00bb6a80f01f03512"

  }
}

variable "aws_region" {
  default = "ap-south-1"

}

variable "eniv" {
    default = "prod"
  
}
