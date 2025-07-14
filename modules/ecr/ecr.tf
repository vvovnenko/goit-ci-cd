resource "aws_ecr_repository" "main" {
  name                 = var.ecr_name
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

# Політика доступу до репозиторію ECR
# Дозволяє ECS (або іншим AWS сервісам) отримувати образи з ECR
resource "aws_ecr_repository_policy" "main_policy" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "AllowECSPull"
        Effect    = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action    = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}
