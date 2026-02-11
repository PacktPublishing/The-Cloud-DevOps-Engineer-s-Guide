resource "aws_s3_bucket" "app_bucket" {

  bucket = "my-unique-devops-book-bucket-12345"

  tags = {
    Name        = "My DevOps Bucket"
    Environment = "Dev"
  }
}