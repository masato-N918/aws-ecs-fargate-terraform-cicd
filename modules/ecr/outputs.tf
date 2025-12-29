output "repository_url" {
  description = "The URL of the ECR repository for the sidecar container"
  value = aws_ecr_repository.sidecar.repository_url
}
