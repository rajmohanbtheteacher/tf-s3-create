aws_region       = "us-east-1"
bucket_name      = "entrata-data-access-bucket"
state_bucket_name = "entrata-terraform-states"
access_group_arns = [
  "arn:aws:iam::123456789012:group/DataTeam",
  "arn:aws:iam::123456789012:group/DevOpsTeam"
]
admin_group_arn = "arn:aws:iam::123456789012:group/AdminTeam"
environment      = "prod"
versioning_enabled = true
encryption_enabled = true
bucket_acl       = "private"

default_tags = {
  Environment = "prod"
  Owner       = "CloudOps"
  ManagedBy   = "Terraform"
  Project     = "S3DataAccess"
} 