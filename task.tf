resource "aws_ecs_task_definition" "ecs_task" {
  family                   = format("%s-%s", var.project_name, var.name)
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  tags = merge(
    var.resource_tags
  )
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      linuxParameters = {
        "initProcessEnabled" : true
      },
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs_cluster_name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.name
        }
      },
      portMappings = [
        {
          name          = var.name
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ],
      healthCheck = length(var.healthCheck) > 0 ? var.healthCheck : null

      environment = [for k, v in var.container_environments : { name : k, value : v }]
      secrets     = [for k, v in var.container_secrets : { name : k, valueFrom : format("%s:%s::", aws_secretsmanager_secret.this[0].arn, k) }]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}