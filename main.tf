# Create the S3 bucket
resource "aws_s3_bucket" "data_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "data_bucket_versioning" {
  bucket = aws_s3_bucket.data_bucket.id
  
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Configure bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "data_bucket_encryption" {
  count = var.encryption_enabled ? 1 : 0
  
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "data_bucket_ownership" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Set bucket ACL
resource "aws_s3_bucket_acl" "data_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.data_bucket_ownership]
  
  bucket = aws_s3_bucket.data_bucket.id
  acl    = var.bucket_acl
}

# Create locals to determine which policy file to use based on environment
locals {
  policy_file = var.environment == "prod" ? "${path.module}/policies/prod_policy.json" : "${path.module}/policies/non_prod_policy.json"
}

# Create bucket policy using environment-specific JSON policy file
resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = templatefile(local.policy_file, {
    bucket_arn       = aws_s3_bucket.data_bucket.arn,
    access_group_arns = jsonencode(var.access_group_arns),
    admin_group_arn   = jsonencode(var.admin_group_arn)
  })
}

# Configure public access block for security
resource "aws_s3_bucket_public_access_block" "data_bucket_public_access" {
  bucket = aws_s3_bucket.data_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 