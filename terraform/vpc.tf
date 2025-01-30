resource "aws_vpc" "deepseekvpc" {
  enable_dns_support = true
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "dssg-subneta" {
    vpc_id = aws_vpc.deepseekvpc.id
    cidr_block = cidrsubnet(aws_vpc.deepseekvpc.cidr_block, 8, 1) #172.16.1.0
    availability_zone = data.aws_availability_zones.availablezones.names[0]
}

resource "aws_subnet" "dssg-subnetb" {
    vpc_id = aws_vpc.deepseekvpc.id
    cidr_block = cidrsubnet(aws_vpc.deepseekvpc.cidr_block, 8, 2) #172.16.2.0
    availability_zone = data.aws_availability_zones.availablezones.names[1]
}

resource "aws_subnet" "dssg-subnetc" {
    vpc_id = aws_vpc.deepseekvpc.id
    cidr_block = cidrsubnet(aws_vpc.deepseekvpc.cidr_block, 8, 3) #172.16.3.0
    availability_zone = data.aws_availability_zones.availablezones.names[2]    
}