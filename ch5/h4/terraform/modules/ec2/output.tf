# Output instance IDs
output "instance_ids" {
  description = "EC2 Instance IDs"
  value       = aws_instance.app[*].id
}

# Output public IPs of the instances
output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.app[*].public_ip
}