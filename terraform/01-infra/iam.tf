# add policy for mongo backups to s3
resource "aws_iam_role_policy" "mongodb_s3" {
  name = "mongodb-s3-backup"
  role = aws_iam_role.mongodb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
// Update to overly-permissive policy
/*      Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
      Resource = [
        module.s3_bucket.s3_bucket_arn,
        "${module.s3_bucket.s3_bucket_arn}/*"
      ]
*/    Action   = ["*"]
      Resource = ["*"]      
    }]
  })
}
# role for mongodb instance for s3
resource "aws_iam_role" "mongodb" {
  name = "mongodb-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}
# attach instance profile to mongodb instance
resource "aws_iam_instance_profile" "mongodb" {
  name = "mongodb-instance-profile"
  role = aws_iam_role.mongodb.name
}


# ECR push policy for tasky app
