output "ecs_role_arn" {
  value = aws_iam_role.ecs_role.arn
}

output "instance_profile_name" {
  value       = aws_iam_instance_profile.instance_profile.name
}