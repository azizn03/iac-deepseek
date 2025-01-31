data "aws_iam_policy_document" "assume_ec2ds_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
    }

  filter {
    name = "architecture"
    values = ["x86_64"]
    }
  }

  data "aws_iam_policy_document" "ds_alb_s3_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.ds_alb_s3_log.arn}/dev/AWSLogs/*",
    ]
  }
}

  data "aws_availability_zones" "availablezones" {
  state = "available"
}

  data "aws_elb_service_account" "main" {}

