resource "aws_security_group" "default_sg" {
  name_prefix = var.name
  description = "Default Security Group for service - ${var.name}"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.resource_tags
}

resource "aws_security_group_rule" "default_egress" {
  security_group_id = aws_security_group.default_sg.id
  type              = "egress"
  description       = "Default Egress Rule for pull container image"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "default_ingress" {
  security_group_id = aws_security_group.default_sg.id
  type              = "ingress"
  description       = "Private Subnets Access"
  protocol          = "tcp"
  from_port         = var.container_port
  to_port           = var.container_port
  cidr_blocks       = local.private_cidrs
}

resource "aws_security_group_rule" "lb_ingress" {
  security_group_id        = aws_security_group.default_sg.id
  type                     = "ingress"
  description              = "LB Ingress Rule"
  protocol                 = "tcp"
  from_port                = var.container_port
  to_port                  = var.container_port
  source_security_group_id = element(tolist(data.aws_lb.main.security_groups), 0)
}

resource "aws_security_group_rule" "postgres_egress" {
  count             = var.postgres_egress ? 1 : 0
  security_group_id = aws_security_group.default_sg.id
  type              = "egress"
  description       = "PostgreSQL database subnets access"
  protocol          = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_blocks       = local.database_cidrs
}