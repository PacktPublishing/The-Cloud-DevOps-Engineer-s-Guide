resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name
}

output "repository_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}