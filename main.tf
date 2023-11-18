terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_eip" "IP" {
  domain = "vpc"
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "NAT" {
  subnet_id     = aws_subnet.Public.id
  allocation_id = aws_eip.IP.id
  depends_on    = [aws_subnet.Public, aws_eip.IP]
}

resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}

resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Private" {
  subnet_id      = aws_subnet.Private.id
  route_table_id = aws_route_table.Private.id
}

resource "aws_security_group" "sg" {
  name        = "Allow SSH and HTTP 8080"
  description = "Allow SSH and HTTP 8080 from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "FastAPI" {
  name        = "FastAPI"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
  port        = 8080
  protocol    = "HTTP"

}

resource "aws_lb_target_group_attachment" "FastAPI" {
  for_each = {
    for k, v in aws_instance.FastAPI : v.id => v
  }
  target_group_arn = aws_lb_target_group.FastAPI.arn
  target_id        = each.value.id
}

data "aws_ami" "Amazon-Linux-2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-minimal-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "local_file" "user_data" {
  filename = "${path.module}/UserData.txt"
}

resource "aws_instance" "FastAPI" {
  ami                         = data.aws_ami.Amazon-Linux-2023.id
  instance_type               = "t3.micro"
  count                       = 5
  user_data                   = data.local_file.user_data.content
  subnet_id                   = aws_subnet.Public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
