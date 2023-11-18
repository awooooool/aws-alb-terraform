resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}

resource "aws_route_table_association" "Public-A" {
  subnet_id      = aws_subnet.Public-A.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Public-B" {
  subnet_id      = aws_subnet.Public-B.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Private-A" {
  subnet_id      = aws_subnet.Private-A.id
  route_table_id = aws_route_table.Private.id
}

resource "aws_route_table_association" "Private-B" {
  subnet_id      = aws_subnet.Private-B.id
  route_table_id = aws_route_table.Private.id
}
