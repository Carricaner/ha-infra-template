provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "ha_template_vpc" {
  cidr_block           = "172.30.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.ha_template_vpc.id
  count             = length(local.available_zones)
  cidr_block        = cidrsubnet(aws_vpc.ha_template_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(local.available_zones, count.index)
  tags = {
    Name = "${local.name_prefix}_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.ha_template_vpc.id
  count             = length(local.available_zones)
  cidr_block        = cidrsubnet(aws_vpc.ha_template_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(local.available_zones, count.index)
  tags = {
    Name = "${local.name_prefix}_private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ha_template_vpc.id
  tags = {
    Name = "${local.name_prefix}_internet_gateway"
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.ha_template_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${local.name_prefix}_public_subnet_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public_subnet_route_table.id
  count          = length(local.available_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

resource "aws_eip" "eip" {
  domain = "vpc"
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
  tags = {
    Name = "${local.name_prefix}_nat_gateway"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.ha_template_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  depends_on = [
    aws_nat_gateway.nat_gateway
  ]
  tags = {
    Name = "${local.name_prefix}_private_subnet_route_table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.private_subnet_route_table.id
  count          = length(local.available_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}