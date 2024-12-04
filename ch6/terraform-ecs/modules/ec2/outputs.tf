output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public ID of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}
