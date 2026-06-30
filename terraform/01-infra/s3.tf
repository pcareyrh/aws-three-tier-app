module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.name}-s3-bucket-test-workingexample"
  acl    = "public-read"
  #acl = "private"
  force_destroy = true
  
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

// Required to create public bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
  versioning = {
    enabled = true
  }
}