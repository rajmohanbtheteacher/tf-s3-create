# Alternative method to read policy from local JSON file
# This demonstrates how to use a data source to read the policy file

# Read the bucket policy from a local file
data "local_file" "bucket_policy_file" {
  filename = "${path.module}/bucket_policy.json"
}

# This is only for demonstration purposes, not actually used in this example
# To use this method instead, replace the policy in aws_s3_bucket_policy with:
# policy = templatefile(data.local_file.bucket_policy_file.content, {
#   bucket_arn       = aws_s3_bucket.data_bucket.arn,
#   access_group_arns = jsonencode(var.access_group_arns)
# })

# Another alternative method is to use a separate JSON policy file for each environment
# and select the appropriate one based on the environment variable

locals {
  # Example of environment-specific policies
  policy_file = var.environment == "prod" ? "policies/prod_policy.json" : "policies/non_prod_policy.json"
  
  # This is just a demonstration of how you might use locals to define which policy to use
  # The actual implementation would require creating those JSON files
} 