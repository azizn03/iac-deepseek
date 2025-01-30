resource "aws_instance" "deepseek_ec2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "g4dn.xlarge"
  iam_instance_profile        = aws_iam_instance_profile.ec2ds_instance_profile.name
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.deepseek_sg.id]
  user_data                   = file("../scripts/user-data.sh")
  
  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "ec2ds-instance"
  }
}
