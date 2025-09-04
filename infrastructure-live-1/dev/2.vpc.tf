# Create VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${local.env}-vpc" }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "${local.env}-igw" }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(local.public_subnets)

  vpc_id = aws_vpc.main.id 
  cidr_block = local.public_subnets[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "${local.env}-public-${count.index + 1}" }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${local.env}-public-rt" }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public-assoc" {
  count = length(local.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# Create Private Subnets
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr 
  availability_zone = each.value.az

  tags = { Name = "${local.env}-private-${each.key}" }
}

# Create NAT Gateway in the first Public Subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = { Name = "${local.env}-nat-eip" }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id 
  subnet_id = aws_subnet.public[0].id

  tags = { Name = "${local.env}-nat" }

    depends_on = [aws_internet_gateway.igw]
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "${local.env}-private-rt" }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private-assoc" {
  for_each = local.private_subnets

  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private-rt.id
}