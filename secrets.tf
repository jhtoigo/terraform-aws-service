resource "aws_secretsmanager_secret" "this" {
  count = var.container_secrets != [] ? 1 : 0
  name  = format("%s/%s/%s", var.project_name, var.environment, var.name)
  tags  = var.resource_tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = var.container_secrets != [] ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = jsonencode(var.container_secrets)
}
