# Repository URL — used for docker tag & push
output "repository_url" {
  value       = aws_ecr_repository.myflask.repository_url
  description = "ECR repository URL for docker push"
}

# Push commands — ready to copy-paste
output "docker_push_commands" {
  value = <<-EOT
    # 1. Authenticate Docker to ECR
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.myflask.repository_url}

    # 2. Tag your image
    docker tag myflask:v1 ${aws_ecr_repository.myflask.repository_url}:v1

    # 3. Push to ECR
    docker push ${aws_ecr_repository.myflask.repository_url}:v1
  EOT
  description = "Commands to push your Docker image to ECR"
}
