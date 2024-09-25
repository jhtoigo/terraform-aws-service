
resource "aws_ecs_service" "ecs_service" {
  name                              = var.name
  cluster                           = data.aws_ecs_cluster.this.arn
  task_definition                   = aws_ecs_task_definition.ecs_task.arn
  desired_count                     = var.desired_count
  enable_execute_command            = true
  health_check_grace_period_seconds = 60
  depends_on                        = [aws_security_group.default_sg]
  platform_version                  = "LATEST"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      base              = capacity_provider_strategy.value.base
      weight            = capacity_provider_strategy.value.weight
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  service_connect_configuration {
    enabled   = true
    namespace = data.aws_service_discovery_http_namespace.this.name
    service {
      discovery_name = var.name
      port_name      = var.name
      client_alias {
        dns_name = var.name
        port     = var.container_port
      }
    }
  }

  load_balancer {
    container_name   = var.name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.main.arn
  }

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.default_sg.id]
    assign_public_ip = false

  }

  tags = var.resource_tags
}