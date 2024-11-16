# Create a VPC
resource "aws_vpc" "project-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

locals {
  azs = ["us-east-1a", "us-east-1b"] 
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true # Automatically assign a public IP for instances in the subnet
  tags = {
    Name = "public-${local.azs[count.index]}"
  }
}


# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.azs[count.index]
  tags = {
    Name = "private-${local.azs[count.index]}"
  }
}