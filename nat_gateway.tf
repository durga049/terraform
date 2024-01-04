resource "aws_vpc" "default" {
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "terra_vpc"
    }
  
}
resource "aws_subnet" "public1" {
    cidr_block = "192.168.1.0/24"
    vpc_id = "${aws_vpc.default.id}"
    availability_zone = "us-east-1a"

}
resource "aws_subnet" "private1" {
    cidr_block = "192.168.2.0/24"
    vpc_id = "${aws_vpc.default.id}"
    availability_zone = "us-east-1b"
  
}
resource "aws_internet_gateway" "gate" {
    vpc_id = "${aws_vpc.default.id}"
  
}

resource "aws_route_table" "route_table" {
    vpc_id = "${aws_vpc.default.id}"
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gate.id}"
        
    }
  
}
resource "aws_route_table_association" "adding_subnet" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.route_table.id}"

  
}
resource "aws_eip" "elastic_ip" {
    vpc = true
  
}
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.elastic_ip.id}"
    subnet_id = "${aws_subnet.public1.id}"
  
}
resource "aws_route_table" "nat_route" {
    vpc_id = "${aws_vpc.default.id}"
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat.id}"
    }
  
}
resource "aws_route_table_association" "default" {
    subnet_id = "${aws_subnet.private1.id}"
    route_table_id = "${aws_route_table.nat_route.id}"
  
}
resource "aws_security_group" "default" {
    vpc_id = "${aws_vpc.default.id}"
    ingress  {        
        from_port =  0 
        to_port =  0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    
    }
    egress  {
        from_port = 0
        to_port =0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
