resource "random_password" "inital_rds_password" {
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "this" {
  name       = "database-sg"
  subnet_ids = [aws_subnet.this.id]

  tags = local.tags
}

resource "aws_db_instance" "this" {
  allocated_storage    = 2
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.0"
  instance_class       = "db.t2.micro"
  name                 = local.database_name
  username             = local.database_username
  password             = random_password.inital_rds_password.result
  port = local.database_port
  parameter_group_name = "default.postgres13.0"
}

resource "aws_secretsmanager_secret" "rds" {
  description = "Generate a secret for the RDS"
  name        = "rds-secret"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = <<EOF
{
  "engine": "postgres",
  "host": "${aws_db_instance.this.address}",
  "username": "${local.database_username}",
  "password": "${random_password.inital_rds_password.result}",
  "dbname": "${local.database_name}",
  "port": "${local.database_port}"
}
EOF
}

# TODO: rotate
# resource "aws_cloudformation_stack" "secrets" {
#   name = "secretsmanager-rotation-stack"

#   parameters = {}
#   template_body = templatefile("./test-application-ecs.json.tpl", {
#     secret_arn
#     rds_arn
#     vpc_security_group_ids
#     vpc_subnet_ids
#   })
# }
