resource "aws_security_group" "Workers" {
  name        = "Allow from Load Balancer"
  description = "Allow HTTP 8080 from load balancer"
  vpc_id      = aws_vpc.Main.id
}

resource "aws_security_group" "Load-Balancer" {
  name        = "Load Balancer"
  description = "Allow HTTP and port 8080 to instances"
  vpc_id      = aws_vpc.Main.id
}

resource "aws_security_group_rule" "Load-Balancer-Ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.Load-Balancer.id
}

resource "aws_security_group_rule" "Load-Balancer-Egress" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.Workers.id
  security_group_id        = aws_security_group.Load-Balancer.id
}

resource "aws_security_group_rule" "Worker-ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.Load-Balancer.id

  security_group_id = aws_security_group.Workers.id
}

resource "aws_security_group_rule" "Worker-Egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.Workers.id
}
