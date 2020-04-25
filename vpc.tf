resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

resource "aws_subnet" "front_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
}

resource "aws_subnet" "front_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"
}

resource "aws_subnet" "back_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"
}

resource "aws_subnet" "back_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
}

resource "aws_route_table" "route_front_end" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "route_back_end" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_1" {
  subnet_id      = aws_subnet.front_1.id
  route_table_id = aws_route_table.route_front_end.id
}

resource "aws_route_table_association" "route_2" {
  subnet_id      = aws_subnet.front_2.id
  route_table_id = aws_route_table.route_front_end.id
}

resource "aws_route_table_association" "route_3" {
  subnet_id      = aws_subnet.back_1.id
  route_table_id = aws_route_table.route_back_end.id
}

resource "aws_route_table_association" "route_4" {
  subnet_id      = aws_subnet.back_2.id
  route_table_id = aws_route_table.route_back_end.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

