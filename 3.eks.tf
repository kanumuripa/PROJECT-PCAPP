#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_eks_cluster" "eks-cluster-1" {
  depends_on = [aws_route_table_association.public-route-asc1]
  name       = "eks-cluster-1"
  role_arn   = "arn:aws:iam::813488695946:role/eks-cluster"

  vpc_config {
    security_group_ids = [aws_security_group.eks-sg.id]
    subnet_ids         = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]
  }
  tags = {
    Name = "eks-cluster-1"
    ENV  = var.tag_env
  }

}

resource "aws_eks_node_group" "node-clust-1" {
  depends_on   = [aws_route_table_association.public-route-asc1]
  cluster_name = aws_eks_cluster.eks-cluster-1.name
  #  key_name                    = "EC2-ssh"
  node_group_name = "node-cluster-1"
  node_role_arn   = "arn:aws:iam::813488695946:role/eks-worker-nodes"
  #  security_group_ids = [aws_security_group.eks-sg.id]
  subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]
  #  associate_public_ip_address = "false"
  #  map_public_ip_on_launch = true


  instance_types = ["t3.medium"]
  disk_size      = 30
  remote_access {
    ec2_ssh_key               = "EC2-ssh"
    source_security_group_ids = [aws_security_group.eks-sg.id]
  }

  scaling_config {
    #    ami_type     = "ami-053b0d53c279acc90"
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  tags = {
    Name = "node-cluster-1"
    ENV  = var.tag_env
  }
  labels = {
    node    = "worker"
    cluster = "cluster-1"
  }
}