variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "splunk_account_name" {
  description = "Splunk account name"
  default = "enterprise-splunk"
}

variable "s3-splunk-buckets" {
  description = "List of S3 Buckets to create the required Splunk Security artifacts."
  default = "s3-bucket"
}

variable "splunk-prefix" {
  description = "Prefix name for all Splunk Security artifacts which include SNS and Queue names."
  default = "splunk-cloud"
}

locals {
  common_tags = "${map(
    "Description", "Managed by Terraform",
    "Team", "Security"
  )}"
}
