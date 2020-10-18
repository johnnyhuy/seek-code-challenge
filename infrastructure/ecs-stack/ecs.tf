data "aws_iam_policy_document" "ecs" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs" {
  name               = "ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# resource "aws_iam_policy" "ecs_secrets" {
#   name = "ecs-secretsmanger-get-secret-value"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "secretsmanager:GetSecretValue"
#       ],
#       "Resource": [
#         "${aws_secretsmanager_secret.rds.id}"
#       ]
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs_secrets" {
#   role       = aws_iam_role.ecs.name
#   policy_arn = aws_iam_policy.ecs_secrets.arn
# }

resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
  description = "Alow inbound access to the ECS task."
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "test-application"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  container_definitions    = templatefile("./test-application-ecs.json.tpl", {
    ds_host = aws_db_instance.this.address
    ds_port = local.database_port
    ds_user = local.database_username
    ds_dbname = local.database_name
    ds_password = aws_secretsmanager_secret.rds.id
  })

  tags = local.tags
}

resource "aws_ecs_cluster" "this" {
  name = "ecs-stack-cluster"

  tags = local.tags
}

resource "aws_ecs_service" "this" {
  name            = "test-application"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "test-application"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.https_forward, aws_iam_role_policy_attachment.ecs]

  tags = local.tags
}
