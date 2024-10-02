resource "aws_lb_target_group" "main" {
  name        = format("tg-%s-%s", var.project_name, var.name)
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = var.resource_tags
  health_check {
    enabled             = true
    interval            = 60
    path                = "/"
    port                = var.container_port
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-499"
  }
}


resource "aws_lb_listener_rule" "main" {
  listener_arn = data.aws_lb_listener.http.arn
  # priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/${var.name}/*"]
    }
  }
}
