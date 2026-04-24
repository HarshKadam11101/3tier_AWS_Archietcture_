resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    name = "${var.env}-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-eip"
  }
}

resource "aws_subnet" "public-subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_app_subnet" {
  count             = length(var.private_app_subnet_cidrs)
  vpc_id            = aws_vpc.primary_vpc.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_db_subnet" {
  count             = length(var.private_db_subnet_cidrs)
  vpc_id            = aws_vpc.primary_vpc.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.primary_vpc.id
  tags = {
    Name = "${var.env}-public-rtb"
  }
}

resource "aws_route" "aws_internet_access" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rtb-association" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public-rtb.id
  subnet_id      = aws_subnet.public-subnet[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.primary_vpc.id
  tags = {
    Name = "${var.env}-private-rtb"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet[0].id
  tags = {
    Name = "${var.env}-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "nat-route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private-app" {
  count          = length(var.private_app_subnet_cidrs)
  subnet_id      = aws_subnet.private_app_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-db" {
  count          = length(var.private_db_subnet_cidrs)
  subnet_id      = aws_subnet.private_db_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}
