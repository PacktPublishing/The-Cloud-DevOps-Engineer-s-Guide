output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.capacity.name
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster_security_group.id
}

output "aws_autoscaling_group_id" {
  value = aws_autoscaling_group.autoscaling_group.id
}