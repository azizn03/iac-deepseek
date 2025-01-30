locals {
  ports = [80, 443]
}

resource "aws_security_group" "deepseek_sg" {
  name        = "deepseek-ec2-sg"
  description = "http/https traffic sg group"
  vpc_id      = aws_vpc.deepseekvpc.id

  dynamic "ingress" {
    for_each = local.ports
    content {
    description = "Allow HTTP-HTTPS"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = ingress.value
    to_port     = ingress.value
  }
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
