output "ec2_public_ip" {
   value    = aws_eip.reverse_proxy_eip.public_ip
}
