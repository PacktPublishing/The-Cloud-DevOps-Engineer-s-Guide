output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket."
  value       = aws_s3_bucket.my_bucket.arn
}