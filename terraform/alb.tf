resource "aws_lb" "ds_alb" {
  name               = "ds_alb"
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = true
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.deepseek_sg]
  subnets            = [aws_subnet.dssg-subneta, aws_subnet.dssg-subnetb, aws_subnet.dssg-subnetc]


  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }
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
  name     = "ds_alb_tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}


resource "aws_lb_target_group_attachment" "ds_tg_attach" {
  target_group_arn = aws_lb_target_group.ds_alb_tg.arn
  target_id        = aws_instance.deepseek_ec2.id
  port             = 80
}