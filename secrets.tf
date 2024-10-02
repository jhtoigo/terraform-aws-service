resource "aws_secretsmanager_secret_version" "this" {
  count         = var.container_secrets != [] ? 1 : 0
  secret_id     = data.aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.container_secrets)

  lifecycle {
    ignore_changes = [secret_string]
  }
}
