resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
}

resource "random_integer" "NAT-AZ" {
  min = 0
  max = var.Total-AZ - 1
}

resource "aws_nat_gateway" "NAT" {
  subnet_id     = aws_subnet.Public[random_integer.NAT-AZ.result].id
  allocation_id = aws_eip.IP.id
  depends_on    = [aws_subnet.Public, aws_eip.IP]
}
