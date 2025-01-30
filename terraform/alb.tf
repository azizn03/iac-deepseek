resource "aws_lb" "ds_alb" {
  name               = "ds-alb"
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = true
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.deepseek_sg.id]
  subnets            = [aws_subnet.dssg-subneta.id, aws_subnet.dssg-subnetb.id, aws_subnet.dssg-subnetc.id]


  access_logs {
    bucket  = aws_s3_bucket.ds_alb_s3_log.id
    prefix  = "dev"
    enabled = true
  }
}

output "alb_dns_name" {
  value = aws_lb.ds_alb.dns_name
}

resource "aws_lb_listener" "dsalb_listener" {
  load_balancer_arn = aws_lb.ds_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ds_alb_tg.arn
  }
}

resource "aws_lb_target_group" "ds_alb_tg" {
  name     = "ds-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.deepseekvpc.id
}

resource "aws_lb_target_group_attachment" "ds_tg_attach" {
  target_group_arn = aws_lb_target_group.ds_alb_tg.arn
  target_id        = aws_instance.deepseek_ec2.id
  port             = 80
}

resource "aws_s3_bucket" "ds_alb_s3_log" {
  bucket = "ds-alb-s3-log"
}