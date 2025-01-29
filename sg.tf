resource "aws_security_group" "deepseek_sg" {
  for_each    = toset(var.http-https-sg)
  name        = "deepseek-ec2-sg"
  description = "http/https traffic sg group"
  vpc_id      = aws_vpc.deepseekvpc.id

  ingress {
    description = "Allow HTTP-HTTPS"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = each.value
    to_port     = each.value
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
