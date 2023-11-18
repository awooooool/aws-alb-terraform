resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "NAT" {
  subnet_id     = aws_subnet.Public-A.id
  allocation_id = aws_eip.IP.id
  depends_on    = [aws_subnet.Public-A, aws_eip.IP]
}
