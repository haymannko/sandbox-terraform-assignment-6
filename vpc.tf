resource "aws_vpc" "peering_vpc1" {
  cidr_block       = var.peering_vpc1.cidr
  instance_tenancy = "default"
  

  tags = {
    Name = var.peering_vpc1.Name
  }
}


resource "aws_vpc" "peering_vpc2" {
  cidr_block       = var.peering_vpc2.cidr
  instance_tenancy = "default"
  

  tags = {
    Name = var.peering_vpc2.Name
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.peering_vpc1.id
  cidr_block = var.cidr_for_public_subnet
  map_public_ip_on_launch = true

  tags = {
    Name = var.name_for_public_subnet
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id     = aws_vpc.peering_vpc2.id
  cidr_block = var.cidr_for_private_subnet
  map_public_ip_on_launch = false

  tags = {
    Name = var.name_for_private_subnet
  }
}

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = aws_vpc.peering_vpc1.id
  vpc_id        = aws_vpc.peering_vpc2.id
  auto_accept = true

  tags = {
    Name = "vpc-peering"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.peering_vpc1.id

  route {
    cidr_block = local.any_where
    gateway_id = aws_internet_gateway.IGW.id
  }

  route {
    cidr_block = aws_vpc.peering_vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.peering_vpc2.id

  route {
    cidr_block = aws_vpc.peering_vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }
  

  tags = {
    Name = "private-RT-confirm"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.peering_vpc1.id

  tags = {
    Name = "internet-GW"
  }
}


resource "aws_route_table_association" "RTAsso1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt.id


  
}

resource "aws_route_table_association" "RTAsso2" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rt.id
  
}

#resource "aws_route" "r1" {
#  route_table_id            = aws_route_table.public-rt.id
#  destination_cidr_block    = "192.168.0.0/16"
#  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  
#  }

#resource "aws_route" "r2" {
# route_table_id            = aws_route_table.private-rt.id
# destination_cidr_block    = "10.0.0.0/16"
# vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
#}
