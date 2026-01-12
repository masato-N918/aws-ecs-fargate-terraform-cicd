# ECR repository for sidecar container

resource "aws_ecr_repository" "sidecar" {
  name = "sidecar"

  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
      Name = "sidecar_ecr_repository"
  }
}

# Lifecycle policy to retain only the last 3 images

resource "aws_ecr_lifecycle_policy" "sidecar_lifecycle" {
  repository = aws_ecr_repository.sidecar.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire old images"
        selection    = {
          tagStatus    = "tagged"
          tagprefixList = [""]
          countType    = "imageCountMoreThan"
          countNumber  = 3
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })
}
