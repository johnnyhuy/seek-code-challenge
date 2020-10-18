resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Alow inbound access for RDS."
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port = local.database_port
    to_port   = local.database_port
    protocol  = "tcp"
    cidr_blocks = [
      # Public subnets
      cidrsubnet(aws_vpc.this.cidr_block, 4, 1),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 2),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 3)
    ]
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
  description = "Alow inbound access to the ECS task."
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

  # TODO: HTTPS setup
  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 443
  #   to_port     = 443
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [
      # Public subnets
      cidrsubnet(aws_vpc.this.cidr_block, 4, 1),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 2),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 3)
    ]
  }

  tags = local.tags
}
