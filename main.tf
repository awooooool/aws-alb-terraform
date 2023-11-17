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

resource "aws_security_group" "sg" {
  name        = "Allow SSH and HTTP 8080"
  description = "Allow SSH and HTTP 8080 from anywhere"

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
  ami                    = data.aws_ami.Amazon-Linux-2023.id
  instance_type          = "t3.micro"
  count                  = 5
  key_name               = "voclab"
  user_data              = data.local_file.user_data.content
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
