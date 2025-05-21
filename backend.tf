terraform {
  backend "s3" {
    bucket         = "entrata-terraform-states"
    key            = "s3-data-access/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
} 