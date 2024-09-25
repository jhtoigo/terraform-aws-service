locals {
  private_cidrs = [for subnet in data.aws_subnet.private_subnets : subnet.cidr_block]
}

locals {
  database_cidrs = [for subnet in data.aws_subnet.databas_subnets : subnet.cidr_block]
}