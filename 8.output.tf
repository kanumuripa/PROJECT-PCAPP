#This will print EC2 public and private IP's. No need to login to AWS console for IP's.
output "ec2-public-ip" {
  value = aws_instance.kubectl.public_ip

}

output "ec2-private-ip" {
  value = aws_instance.kubectl.private_ip

}

output "private-subnet-1a" {
  value = aws_subnet.private-subnet-1a.id

}

output "private-subnet-1b" {
  value = aws_subnet.private-subnet-1b.id

}