resource "aws_vpc" "main" {
 cidr_block ="10.0.0.0/16"

    tags = {
        Name = "main-vpc"
    }
}

## Create Public and Private Subnets in ap-northeast-1a and ap-northeast-1c

resource "aws_subnet" "public-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public-subnet-1c"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-subnet-1c"
  }
}

## Create Internet Gateway and Public Route Table

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "public-1a-assoc" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-1c-assoc" {
  subnet_id      = aws_subnet.public-1c.id
  route_table_id = aws_route_table.public-rt.id
}

## Create Private Route Table and NAT Gateways

resource "aws_route_table" "private-rt-1a" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-rt-1a"
    }
}
resource "aws_route_table" "private-rt-1c" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-rt-1c"
    }
}

resource "aws_route" "private-rt-1a-nat-route" {
  route_table_id         = aws_route_table.private-rt-1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1a.id
}

resource "aws_route" "private-rt-1c-nat-route" {
  route_table_id         = aws_route_table.private-rt-1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1c.id
}

resource "aws_route_table_association" "private-1a-assoc" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-rt-1a.id
}

resource "aws_route_table_association" "private-1c-assoc" {
  subnet_id      = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private-rt-1c.id
}

resource "aws_nat_gateway" "nat-gw-1a" {
  allocation_id = aws_eip.nat-eip-1a.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = "nat-gw-1a"
  }
}
resource "aws_eip" "nat-eip-1a" {
    domain = "vpc"

  tags = {
    Name = "nat-eip-1a"
  }
}

resource "aws_nat_gateway" "nat-gw-1c" {
  allocation_id = aws_eip.nat-eip-1c.id
  subnet_id     = aws_subnet.public-1c.id

  tags = {
    Name = "nat-gw-1c"
  }
}

resource "aws_eip" "nat-eip-1c" {
    domain = "vpc"

  tags = {
    Name = "nat-eip-1c"
  }
}


