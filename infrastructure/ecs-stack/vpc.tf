resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

resource "aws_vpc" "this" {
  cidr_block = cidrsubnet("10.0.0.0/16", 4, 1)

  tags = local.tags
}

resource "aws_subnet" "a" {
  availability_zone = "ap-southeast-2a"
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 4, 1)
}

resource "aws_subnet" "b" {
  availability_zone = "ap-southeast-2b"
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 4, 2)
}

resource "aws_subnet" "c" {
  availability_zone = "ap-southeast-2c"
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 4, 3)
}
