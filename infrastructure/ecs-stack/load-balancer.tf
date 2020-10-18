resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "Allow internet ingress from the load balancer."
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_lb" "this" {
  depends_on = [aws_internet_gateway.this]

  name               = "ecs-stack-lb"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]

  tags = local.tags
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = "ecs-stack-target"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    path     = "/actuator/health"
    protocol = "HTTP"
    interval = 60
  }

  tags = local.tags
}
