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
  ami                         = data.aws_ami.Amazon-Linux-2023.id
  instance_type               = "t3.micro"
  count                       = var.Instances-Count
  user_data                   = data.local_file.user_data.content
  subnet_id                   = aws_subnet.Private.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.Workers.id]

  tags = {
    Name      = "FastAPI"
    ManagedBy = "Terraform"
  }
}
