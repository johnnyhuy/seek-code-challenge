locals {
  database_username = "john"
  database_name = "test"
  database_port = 5432

  tags = {
    Environment = "production"
    Owner       = "info@johnnyhuy.com"
    Application = "ECS Stack"
  }
}
