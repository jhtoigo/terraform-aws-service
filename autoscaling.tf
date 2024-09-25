resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.min_capacity != null && var.max_capacity != null ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_ecs_service.ecs_service]
}

resource "aws_appautoscaling_policy" "ecs_policy_up" {
  count = length(aws_appautoscaling_target.ecs_target) > 0 ? 1 : 0

  name               = "scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 60
    scale_in_cooldown  = 30
    scale_out_cooldown = 180
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_mem_up" {
  count = length(aws_appautoscaling_target.ecs_target) > 0 ? 1 : 0

  name               = "scale-mem-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 70
    scale_in_cooldown  = 30
    scale_out_cooldown = 180
  }
}


resource "aws_appautoscaling_scheduled_action" "schedules" {
  count              = length(aws_appautoscaling_target.ecs_target) > 0 ? length(var.schedule) : 0
  name               = "schedule-${count.index}"
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  timezone           = "America/Sao_Paulo"
  schedule           = var.schedule[count.index].schedule

  scalable_target_action {
    min_capacity = var.schedule[count.index].min_capacity
    max_capacity = var.schedule[count.index].max_capacity
  }
}