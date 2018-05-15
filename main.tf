module "spunk-artifacts" {
  source = "modules/splunk"
  s3-splunk-buckets = "${var.s3-splunk-buckets-list}"
  splunk-prefix = "${var.splunk-prefix}"
}
