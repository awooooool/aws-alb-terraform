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

resource "aws_instance" "FastAPI" {
  ami           = data.aws_ami.Amazon-Linux-2023.id
  instance_type = "t3.micro"
  count         = 5
  user_data     = <<EOF
        #!/bin/bash

        #### THIS USERDATA WILL RUN FASTAPI WITH ROOT USER, BE WARNED!!!

        yum install tmux python-pip git -y
        git clone https://github.com/awooooool/aws-load-balancer-test.git /opt/aws-load-balancer-test
        pip install -r /opt/aws-load-balancer-test/requirements.txt
        tmux new-session -d -s fastapi "cd /opt/aws-load-balancer-test; uvicorn main:app --host 0.0.0.0 --port 8080;"
    EOF

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
