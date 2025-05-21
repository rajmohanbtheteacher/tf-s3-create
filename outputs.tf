output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.data_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.data_bucket.arn
}

output "bucket_region" {
  description = "The region of the created S3 bucket"
  value       = aws_s3_bucket.data_bucket.region
}

output "bucket_domain_name" {
  description = "The domain name of the created S3 bucket"
  value       = aws_s3_bucket.data_bucket.bucket_domain_name
}

output "state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform state"
  value       = var.state_bucket_name
} 