resource "aws_subnet" "Public-A" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"
}

resource "aws_subnet" "Public-B" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1b"
}

resource "aws_subnet" "Private-A" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.10.0/24"
}

resource "aws_subnet" "Private-B" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.11.0/24"
}
