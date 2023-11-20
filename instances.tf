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

variable "Instances-Count" {
  type = number
}

resource "random_shuffle" "Instances-Subnet" {
  input        = aws_subnet.Private[*].id
  count        = var.Instances-Count
  result_count = 1
}

resource "aws_instance" "FastAPI" {
  for_each = {
    for k, az in random_shuffle.Instances-Subnet : k => az
  }
  ami                         = data.aws_ami.Amazon-Linux-2023.id
  instance_type               = "t3.micro"
  user_data                   = data.local_file.user_data.content
  subnet_id                   = each.value.result[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.Workers.id]
  depends_on                  = [aws_nat_gateway.NAT] // To wait for NAT Gateway to active before deploying instance

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
