resource "aws_vpc" "main" {
 cidr_block ="10.0.0.0/16"

    tags = {
        Name = "main-vpc"
    }
}

## Create Public and Private Subnets in ap-northeast-1a and ap-northeast-1c

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public_subnet_1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public_subnet_1c"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private_subnet_1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private_subnet_1c"
  }
}

## Create Internet Gateway and Public Route Table

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
        Name = "public_rt"
    }
}

resource "aws_route_table_association" "public_1a_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1c_assoc" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_rt.id
}

## Create Private Route Table and NAT Gateways

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "private_rt_1a"
    }
}
resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "private_rt_1c"
    }
}

resource "aws_route" "private_rt_1a_nat_route" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}

resource "aws_route" "private_rt_1c_nat_route" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1c.id
}

resource "aws_route_table_association" "private_1a_assoc" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private_1c_assoc" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}

resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "nat_gw_1a"
  }
}
resource "aws_eip" "nat_eip_1a" {
    domain = "vpc"

  tags = {
    Name = "nat_eip_1a"
  }
}

resource "aws_nat_gateway" "nat_gw_1c" {
  allocation_id = aws_eip.nat_eip_1c.id
  subnet_id     = aws_subnet.public_1c.id

  tags = {
    Name = "nat_gw_1c"
  }
}

resource "aws_eip" "nat_eip_1c" {
    domain = "vpc"

  tags = {
    Name = "nat_eip_1c"
  }
}


