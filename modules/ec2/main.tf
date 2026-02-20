resource "aws_instance" "reverse_proxy" {
   ami                            = data.aws_ami.amazon_linux.id
   instance_type                  = "t2.micro"

   subnet_id                      = var.public_subnet_id
   vpc_security_group_ids         = [var.ec2_sg_id]
   associate_public_ip_address    = false

   user_data  = file("${path.module}/user_data.sh")

   tags = {
    Name = "${var.name_prefix}-reverse-proxy"
    }
}

resource "aws_eip" "reverse_proxy_eip" {
  instance    = aws_instance.reverse_proxy.id
  domain      = "vpc"
}

data "aws_ami" "amazon_linux" {
  most_recent   = true

  owners        = ["amazon"]

  filter {
   name     = "name"
   values   = ["al2023-ami-*-x86_64"]
  }

  filter {
    name     = "virtualization-type"
    values   = ["hvm"]
  }

}
