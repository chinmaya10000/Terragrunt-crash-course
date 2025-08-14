resource "aws_subnet" "private-us-east-2a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/19"
  availability_zone = "us-east-2a"

  tags = {
    "Name" = "staging-private-subnet-us-east-2a"
    "kubernetes.io/cluster/staging-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private-us-east-2b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.32.0/19"
  availability_zone = "us-east-2b"

  tags = {
    "Name" = "staging-private-subnet-us-east-2b"
    "kubernetes.io/cluster/staging-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "public-us-east-2a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.64.0/19"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "staging-public-subnet-us-east-2a"
    "kubernetes.io/cluster/staging-cluster" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public-us-east-2b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.96.0/19"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "staging-public-subnet-us-east-2b"
    "kubernetes.io/cluster/staging-cluster" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}