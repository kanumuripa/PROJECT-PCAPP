#VPC for eks cluster (this will be used only for nodes. EKS cluster will use AWS vpc)
resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks-vpc"
    ENV  = var.tag_env
  }
}

# IGW for public access servers
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-igw"
    ENV  = var.tag_env
  }
}
# Public subnet for web and others servers which needs public access
resource "aws_subnet" "public-subnet-1a" {
  depends_on              = [aws_vpc.eks-vpc]
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a"
    ENV  = var.tag_env
    name = "public"
  }
}


# Public subnet for web and others servers which needs public access
resource "aws_subnet" "public-subnet-1b" {
  depends_on              = [aws_vpc.eks-vpc]
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1b"
    ENV  = var.tag_env
    name = "public"
  }
}

# Private subnet for servers doesn't required public access
resource "aws_subnet" "private-subnet-1a" {
  depends_on        = [aws_subnet.public-subnet-1b]
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.128.0/18"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a"
    ENV  = var.tag_env
    name = "private"
  }
}

# Private subnet for servers doesn't required public access
resource "aws_subnet" "private-subnet-1b" {
  depends_on        = [aws_subnet.public-subnet-1b]
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.192.0/18"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-1b"
    ENV  = var.tag_env
    name = "private"
  }
}

# Public routetable and IGW attached to it
resource "aws_route_table" "public-route" {
  depends_on = [aws_subnet.public-subnet-1b]
  vpc_id     = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }


  tags = {
    Name = "public-route"
    ENV  = var.tag_env
  }
}
#Private route table with NGW attached to it
resource "aws_route_table" "private-route" {
  depends_on = [aws_route_table.public-route, aws_nat_gateway.eks-natgw]
  vpc_id     = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks-natgw.id
  }

  tags = {
    Name = "private-route"
    ENV  = var.tag_env
  }
}
# EIP for nat gateway
resource "aws_eip" "eks-eip" {
  vpc = true

  tags = {
    Name = "eks-cluster"
    ENV  = var.tag_env
  }
}

#Nat gateway for private subnet to provide access to internet for pacthing and etc
resource "aws_nat_gateway" "eks-natgw" {
  allocation_id = aws_eip.eks-eip.id
  subnet_id     = aws_subnet.public-subnet-1a.id

  tags = {
    Name = "eks-natgw"
    ENV  = var.tag_env
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eks-eip]
}

# Below to are route table associations with public and private routes.

resource "aws_route_table_association" "public-route-asc" {
  depends_on     = [aws_route_table.public-route]
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-route.id

}

resource "aws_route_table_association" "private-route-asc" {
  depends_on     = [aws_route_table.private-route]
  subnet_id      = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.private-route.id

}
resource "aws_route_table_association" "public-route-asc1" {
  depends_on     = [aws_route_table.public-route]
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public-route.id

}

resource "aws_route_table_association" "private-route-asc1" {
  depends_on     = [aws_route_table.private-route]
  subnet_id      = aws_subnet.private-subnet-1b.id
  route_table_id = aws_route_table.private-route.id

}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "rds-private-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]
}