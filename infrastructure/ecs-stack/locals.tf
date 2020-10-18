locals {
  database_username = "john"
  database_name = "test"
  database_port = 5432

  # public_subnets = {
  #   "ap-southeast-2a" = 1
  #   "ap-southeast-2b" = 2
  #   "ap-southeast-2c" = 3
  # }

  # private_subnets = {
  #   "ap-southeast-2a" = 4
  #   "ap-southeast-2b" = 5
  #   "ap-southeast-2c" = 6
  # }

  tags = {
    Environment = "production"
    Owner       = "info@johnnyhuy.com"
    Application = "ECS Stack"
  }
}
