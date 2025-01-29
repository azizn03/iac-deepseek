resource "aws_vpc" "deepseekvpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.deepseekvpc
    cidr_block = "172.16.1.0/24"
}