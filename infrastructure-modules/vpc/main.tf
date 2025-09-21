resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = { Name = "${var.env}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "${var.env}-igw" }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]

  tags = { Name = "${var.env}-public-${count.index + 1}" }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.env}-public-rt" }
}

# Associate Public Subnets with Public RT
resource "aws_route_table_association" "public-assoc" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = { Name = "${var.env}-private-${each.key}" }
}

# Nat Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = { Name = "${var.env}-nat-eip" }
  
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public[0].id

  tags = { Name = "${var.env}-nat" }

  depends_on = [ aws_internet_gateway.igw ]
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "${var.env}-private-rt" } 
}

# Associate Private Subnets with Private RT
resource "aws_route_table_association" "private-assoc" {
  for_each = var.private_subnets
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}