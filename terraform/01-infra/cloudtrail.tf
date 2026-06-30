resource "aws_cloudtrail" "cloudtrail" {
  depends_on = [aws_s3_bucket_policy.cloudtrail-bucket]

  name                          = "${var.name}-cloudtrail-logs-3tier"
  s3_bucket_name                = aws_s3_bucket.cloudtrail-bucket.id
  s3_key_prefix                 = "3tier-app"
  include_global_service_events = true

    event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
}

resource "random_string" "cloudtrail_bucket_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "aws_s3_bucket" "cloudtrail-bucket" {
  bucket        = "${var.name}-cloudtrail-3tier-trail-${random_string.cloudtrail_bucket_suffix.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "cloudtrail-policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail-bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail-bucket.arn}/3tier-app/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail-bucket" {
  bucket = aws_s3_bucket.cloudtrail-bucket.id
  policy = data.aws_iam_policy_document.cloudtrail-policy.json
}

data "aws_partition" "current" {}

data "aws_region" "current" {}