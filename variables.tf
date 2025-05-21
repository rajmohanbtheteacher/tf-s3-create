variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
}

variable "access_group_arns" {
  description = "List of IAM group ARNs that need full access to the bucket"
  type        = list(string)
}

variable "admin_group_arn" {
  description = "ARN of the admin IAM group that has delete permissions in production"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment (e.g., prod, dev, stage)"
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "encryption_enabled" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_acl" {
  description = "ACL for the S3 bucket"
  type        = string
  default     = "private"
} 