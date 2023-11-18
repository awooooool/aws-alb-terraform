resource "aws_lb_target_group" "FastAPI" {
  name        = "FastAPI"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
  port        = 8080
  protocol    = "HTTP"

}

resource "aws_lb_target_group_attachment" "FastAPI" {
  for_each = {
    for k, v in aws_instance.FastAPI : k => v
  }
  target_group_arn = aws_lb_target_group.FastAPI.arn
  target_id        = each.value.id
}

resource "aws_lb" "LoadBalancer" {
  name               = "FastAPI-LoadBalancer"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.Load-Balancer.id]
  subnets            = [aws_subnet.Public-A.id, aws_subnet.Public-B.id]
}

resource "aws_lb_listener" "LoadBalancer" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FastAPI.arn
  }
}
