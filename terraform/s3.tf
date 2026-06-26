module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.name}-s3-bucket-test-workingexample"
  #acl    = "public-read"
  acl = "private"
  force_destroy = true
  
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}