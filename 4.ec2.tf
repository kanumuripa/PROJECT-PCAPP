# From this instance we can run our kubectl, aws and eksctl commands. I used this to connectivity.
# Created this to test Private and public subnets. we can test IGW and NAT gateway using below instance.
resource "aws_instance" "kubectl" {
  depends_on                  = [aws_eks_cluster.eks-cluster-1, aws_eks_node_group.node-clust-1]
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "EC2-ssh"
  vpc_security_group_ids      = [aws_security_group.eks-sg.id]
  subnet_id                   = aws_subnet.public-subnet-1a.id

  tags = {
    Name = "kubectl"
    ENV  = var.tag_env
  }
  #Used below provisioners to copy key file to VM with public access. this will help to connect to VMs in Private subnets and to perform ping test.  
  provisioner "file" {
    source      = "EC2-ssh.pem"
    destination = "/home/ubuntu/EC2-ssh.pem"
  }
  provisioner "file" {
    source      = "ec2.sh"
    destination = "/home/ubuntu/ec2.sh"
  }

  provisioner "file" {
    source      = "argo.sh"
    destination = "/home/ubuntu/argo.sh"
  }

  provisioner "file" {
    source      = "ansible.yaml"
    destination = "/home/ubuntu/ansible.yaml"
  }

  provisioner "file" {
    source      = "pro-grafana.sh"
    destination = "/home/ubuntu/pro-grafana.sh"
  }

  provisioner "file" {
    source      = "prometheus-datasource.yaml"
    destination = "/home/ubuntu/prometheus-datasource.yaml"
  }
  
  provisioner "file" {
    source      = "rds-deployment/"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sudo chmod 400 /home/ubuntu/EC2-ssh.pem",
      "sudo sudo chmod 775 /home/ubuntu/ec2.sh",
      "sudo sudo chmod 775 /home/ubuntu/argo.sh",
      "sudo sudo chmod 775 /home/ubuntu/pro-grafana.sh",
      "sudo sh /home/ubuntu/ec2.sh",
      "sudo sh /home/ubuntu/pro-grafana.sh",
      #      "ansible-playbook ansible.yaml",
      "sudo sh /home/ubuntu/argo.sh",
      #      "sudo ah /home/ubuntu/pro-grafana.sh"
      #      "sudo reboot"

      # "sudo echo 'kubectl' >/etc/hostname",
    ]

  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/bhavyasri/EC2-ssh.pem")
  }
}