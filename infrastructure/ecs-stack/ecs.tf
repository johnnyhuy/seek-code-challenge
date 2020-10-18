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

resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs-logs"

  tags = local.tags
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

resource "aws_iam_policy" "ecs_logs" {
  name = "ecs-logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_logs" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecs_logs.arn
}

resource "aws_iam_policy" "ecs_secrets" {
  name = "ecs-secretsmanger-get-secret-value"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "${aws_secretsmanager_secret.rds.id}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_secrets" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecs_secrets.arn
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

# WARNING! Before destroying, please remove any active tasks in the service otherwise the destruction process will hang and error
resource "aws_ecs_service" "this" {
  depends_on = [aws_db_instance.this, aws_lb_listener.https_forward, aws_iam_role_policy_attachment.ecs]

  name            = "test-application"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "test-application"
    container_port   = 8080
  }

  tags = local.tags
}
