resource "random_password" "inital_rds_password" {
  length  = 16
  special = false
}

resource "random_string" "secret" {
  length  = 4
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "database-sg"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]

  tags = local.tags
}

resource "aws_db_instance" "this" {
  depends_on = [aws_db_subnet_group.this]

  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.3"
  instance_class       = "db.t2.micro"
  name                 = local.database_name
  username             = local.database_username
  password             = random_password.inital_rds_password.result
  port                 = local.database_port
  db_subnet_group_name = "database-sg"
  skip_final_snapshot  = true

  tags = local.tags
}

resource "aws_secretsmanager_secret" "rds" {
  description = "Generate a secret for the RDS"
  name        = "${random_string.secret.result}-rds-secret" # when we delete secrets it takes time, we can make it unique instead

  tags = local.tags
}

# resource "aws_secretsmanager_secret_version" "rds" {
#   secret_id     = aws_secretsmanager_secret.rds.id
#   secret_string = <<EOF
# {
#   "engine": "postgres",
#   "host": "${aws_db_instance.this.address}",
#   "username": "${local.database_username}",
#   "password": "${random_password.inital_rds_password.result}",
#   "dbname": "${local.database_name}",
#   "port": "${local.database_port}"
# }
# EOF
# }

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = random_password.inital_rds_password.result
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
