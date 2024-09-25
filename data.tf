## ECS Cluster

data "aws_ecs_cluster" "this" {
  cluster_name = var.ecs_cluster_name
}

data "aws_service_discovery_http_namespace" "this" {
  name = var.project_name
}

## Private Subnets

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

## Database Subnets

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["*database*"]
  }
}

data "aws_subnet" "databas_subnets" {
  for_each = toset(data.aws_subnets.database.ids)
  id       = each.value
}

## Load Balancer

data "aws_lb" "main" {
  name = "${var.project_name}-alb"
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 443
}