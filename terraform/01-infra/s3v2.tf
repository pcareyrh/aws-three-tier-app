resource "random_string" "cloudtrail_bucket_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "aws_s3_bucket" "cloudtrail-bucket" {
  bucket        = "${var.name}-mydemo-${random_string.cloudtrail_bucket_suffix.result}"
  force_destroy = true
}
