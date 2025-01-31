resource "aws_lb" "ds_alb" {
  name                = "ds-alb"
  internal           = false
  enable_deletion_protection = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.deepseek_sg.id]
  subnets            = [aws_subnet.dssg-subneta.id, aws_subnet.dssg-subnetb.id, aws_subnet.dssg-subnetc.id]

  access_logs {
    bucket  = aws_s3_bucket.ds_alb_s3_log.id
    prefix  = "dev"
    enabled = true
  }
  depends_on = [aws_s3_bucket.ds_alb_s3_log, aws_s3_bucket_policy.ds_alb_s3_policy]
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
  bucket_prefix = "ds-alb-s3-log-"
  force_destroy = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "ds_al_encryption" {
  bucket = aws_s3_bucket.ds_alb_s3_log.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}