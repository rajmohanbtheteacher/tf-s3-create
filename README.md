# 🪣 S3 Bucket with Dynamic Policy Management

![AWS S3](https://img.shields.io/badge/AWS-S3-FF9900?style=for-the-badge&logo=amazon-aws)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-0080FF?style=for-the-badge)

This Terraform project creates an S3 bucket with environment-specific access policies and complete infrastructure setup for maintaining state in S3 with DynamoDB locking.

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [File Structure](#-file-structure)
- [Workflow](#-workflow)
- [Security Features](#-security-features)
- [Deployment Steps](#-deployment-steps)
- [Customization](#-customization)
- [Troubleshooting](#-troubleshooting)

## 🏗️ Architecture Overview

```
                         ┌───────────────────┐
                         │                   │
                         │  Terraform State  │
                         │    S3 Bucket      │◄────────┐
                         │                   │         │
                         └───────────────────┘         │ Stores State
                                  ▲                    │
                                  │ Locks              │
                                  │                    │
                         ┌───────────────────┐         │
                         │                   │         │
                         │  DynamoDB Lock    │         │
                         │     Table         │         │
                         │                   │         │
                         └───────────────────┘         │
                                                       │
┌─────────────────────────────────────────────────────┐│
│                                                     ││
│               Terraform Configuration               ││
│                                                     ││
│  ┌─────────────┐   ┌─────────────┐   ┌──────────┐   ││
│  │             │   │             │   │          │   ││
│  │  variables  │◄─►│    main     │◄─►│ backend  │───┘│
│  │             │   │             │   │          │    │
│  └─────────────┘   └─────────────┘   └──────────┘    │
│         ▲                 │                          │
│         │                 ▼                          │
│  ┌─────────────┐   ┌─────────────┐                   │
│  │             │   │             │                   │
│  │  terraform  │   │   outputs   │                   │
│  │   .tfvars   │   │             │                   │
│  │             │   └─────────────┘                   │
│  └─────────────┘                                     │
│                                                      │
└──────────────────────────────────────────────────────┘
          │                      ▲
          │                      │  Creates
          ▼                      │
┌───────────────────────────────────────────────────┐
│                                                   │
│               Policy Management                   │
│                                                   │
│  ┌────────────────┐     ┌────────────────────┐    │
│  │                │     │                    │    │
│  │ bucket_policy  │     │ Environment-based  │    │
│  │     .json      │     │  Policy Selection  │    │
│  │                │     │                    │    │
│  └────────────────┘     └────────────────────┘    │
│         │                        │                 │
│         │                        │                 │
│         ▼                        ▼                 │
│  ┌────────────────┐     ┌────────────────────┐    │
│  │                │     │                    │    │
│  │  prod_policy   │     │   non_prod_policy  │    │
│  │     .json      │     │       .json        │    │
│  │                │     │                    │    │
│  └────────────────┘     └────────────────────┘    │
│                                                   │
└───────────────────────────────────────────────────┘
          │
          │  Creates & Applies
          ▼
┌───────────────────────────────────────────────────┐
│                                                   │
│                   AWS Resources                   │
│                                                   │
│  ┌────────────────┐     ┌────────────────────┐    │
│  │                │     │                    │    │
│  │    S3 Bucket   │◄────┤  S3 Bucket Policy  │    │
│  │                │     │                    │    │
│  └────────────────┘     └────────────────────┘    │
│         │                                          │
│         │                                          │
│         ▼                                          │
│  ┌────────────────────────────────────────┐        │
│  │                                        │        │
│  │          S3 Bucket Features            │        │
│  │                                        │        │
│  │  ● Encryption                          │        │
│  │  ● Versioning                          │        │
│  │  ● Access Controls                     │        │
│  │  ● Public Access Blocks                │        │
│  │                                        │        │
│  └────────────────────────────────────────┘        │
│                                                   │
└───────────────────────────────────────────────────┘
```

## 📁 File Structure

| File | Description |
|------|-------------|
| 📄 `main.tf` | Core resource configuration for S3 bucket and dynamic policy selection |
| 📄 `variables.tf` | Input variable definitions with descriptions and defaults |
| 📄 `terraform.tfvars` | Variable values for your specific deployment |
| 📄 `provider.tf` | AWS provider configuration and version constraints |
| 📄 `backend.tf` | Remote state configuration in S3 with DynamoDB locking |
| 📄 `outputs.tf` | Output values to reference after deployment |
| 📄 `dynamo_lock.tf` | DynamoDB table configuration for state locking |
| 📄 `data_sources.tf` | Alternative approaches for JSON policy handling |
| 📄 `bucket_policy.json` | Base bucket policy template in JSON format |
| 📁 `policies/` | Directory containing environment-specific policies |
| 📄 `policies/prod_policy.json` | Production environment policy with enhanced security |
| 📄 `policies/non_prod_policy.json` | Development/testing environment policy |

## 🔄 Workflow

1. **Initialize** - `terraform init` reads the backend configuration from `backend.tf` to set up remote state
2. **Configuration Loading** - Terraform reads:
   - Variable definitions from `variables.tf`
   - Values from `terraform.tfvars`
   - Provider settings from `provider.tf`
3. **Resource Planning** - `terraform plan` evaluates:
   - S3 bucket creation in `main.tf`
   - Policy selection based on environment variable
   - Appropriate JSON policy loading using `templatefile()` function
4. **Policy Application** - Dynamic selection of:
   - `prod_policy.json` for production environments (with MFA and admin restrictions)
   - `non_prod_policy.json` for development environments
5. **Resource Creation** - `terraform apply` creates:
   - S3 bucket with versioning, encryption, and access controls
   - DynamoDB lock table for state management
   - Applied bucket policy based on environment

## 🔒 Security Features

| 🛡️ Feature | Production | Non-Production |
|------------|------------|----------------|
| **Encryption Enforcement** | ✅ Required | ✅ Required |
| **HTTPS Enforcement** | ✅ Required | ✅ Required |
| **Delete Restrictions** | ✅ Admin-only | ❌ Not restricted |
| **MFA Requirement** | ✅ Required | ❌ Not required |
| **Public Access Block** | ✅ Enabled | ✅ Enabled |
| **Bucket Versioning** | ✅ Enabled | ✅ Enabled (configurable) |

## 🚀 Deployment Steps

1. **Configure Variables**
   ```bash
   # Edit terraform.tfvars to set your environment
   vim terraform.tfvars
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review Plan**
   ```bash
   terraform plan
   ```

4. **Deploy Infrastructure**
   ```bash
   terraform apply
   ```

5. **Verify Outputs**
   ```bash
   terraform output
   ```

## 🔧 Customization

### Custom Policy Extensions

You can extend the existing policies with additional statements:

```json
{
  "Sid": "CustomPolicyStatement",
  "Effect": "Allow",
  "Principal": {
    "AWS": "${specific_user_arn}"
  },
  "Action": ["specific:Actions"],
  "Resource": ["${bucket_arn}/path/*"]
}
```

### Environment Expansion

To add new environments:

1. Create a new policy JSON file (e.g., `staging_policy.json`)
2. Update the policy selection logic in `main.tf`:

```hcl
locals {
  policy_file = {
    "prod"    = "${path.module}/policies/prod_policy.json"
    "staging" = "${path.module}/policies/staging_policy.json"
    "dev"     = "${path.module}/policies/non_prod_policy.json"
  }[var.environment]
}
```

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| **State Bucket Not Found** | Create the state bucket manually before running `terraform init` |
| **Policy Application Failing** | Check IAM permissions and verify JSON syntax in policy files |
| **"Invalid Principal" Error** | Ensure group ARNs are valid and properly formatted in `terraform.tfvars` |
| **Lock Table Contention** | Use `terraform force-unlock [LOCK_ID]` if needed (use cautiously) |

---

## 📊 Resource Details

### S3 Bucket Features

- **Bucket Ownership:** BucketOwnerPreferred
- **Access Control:** Private by default, customizable via variables
- **Encryption:** AES-256 server-side encryption
- **Versioning:** Enabled by default, configurable via variables
- **Lifecycle Policies:** Prevent accidental destruction

### Example IAM Group Access

```hcl
access_group_arns = [
  "arn:aws:iam::123456789012:group/DataTeam",
  "arn:aws:iam::123456789012:group/DevOpsTeam"
]
admin_group_arn = "arn:aws:iam::123456789012:group/AdminTeam"
```

---

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%20by-Cloud%20Team-blue?style=for-the-badge" alt="Maintained by Cloud Team">
</p> 
