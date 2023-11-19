resource "random_shuffle" "Subnet-AZ" {
  input        = data.aws_availability_zones.Subnets-AZ.names
  result_count = 2
}

resource "aws_subnet" "Public-A" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = random_shuffle.Subnet-AZ.result[0]
}

resource "aws_subnet" "Public-B" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = random_shuffle.Subnet-AZ.result[1]
}

resource "aws_subnet" "Private-A" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = random_shuffle.Subnet-AZ.result[0]
}

resource "aws_subnet" "Private-B" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = random_shuffle.Subnet-AZ.result[1]
}
