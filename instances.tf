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

resource "aws_instance" "FastAPI" {
  count                       = var.Instances-Count
  ami                         = data.aws_ami.Amazon-Linux-2023.id
  instance_type               = "t3.micro"
  user_data                   = data.local_file.user_data.content
  subnet_id                   = aws_subnet.Private[count.index % var.Total-AZ].id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.Workers.id]
  depends_on                  = [aws_nat_gateway.NAT] // To wait for NAT Gateway to active before deploying instance

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
