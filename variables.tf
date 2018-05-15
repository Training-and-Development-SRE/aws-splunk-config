variable "s3-splunk-buckets-list" {
  description = "List of S3 Buckets to create the required Splunk Security artifacts."
  default = "config"
}

variable "splunk-prefix" {
  description = "Prefix name for all Splunk Security artifacts which include SNS and Queue names."
  default = "splunk-cloud"
}
