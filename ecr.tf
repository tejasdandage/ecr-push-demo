# ECR Repository
resource "aws_ecr_repository" "myflask" {
  name                 = "myflask"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Scan images for vulnerabilities when pushed
  }

  tags = {
    Project = "docker-day4"
    ManagedBy = "terraform"
  }
}

# Lifecycle policy — auto-delete untagged images older than 7 days
resource "aws_ecr_lifecycle_policy" "myflask" {
  repository = aws_ecr_repository.myflask.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
