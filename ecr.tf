resource "aws_ecr_repository" "ecr_repository" {
  name                 = format("%s-%s", var.project_name, var.name)
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "lc_ecr_repository" {
  repository = aws_ecr_repository.ecr_repository.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 20 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
    }]
  })
}