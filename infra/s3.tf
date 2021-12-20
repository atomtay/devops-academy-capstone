resource "random_uuid" "random_id" {}

resource "aws_s3_bucket" "frontend" {
  #checkov:skip=CKV2_AWS_6:Website should be publicly accessible
  #checkov:skip=CKV_AWS_19:Don't encrypt publicly accessible website
  #checkov:skip=CKV_AWS_20:Website should be publicly accessible
  #checkov:skip=CKV_AWS_21:Versioning of websited is handled through git
  #checkov:skip=CKV_AWS_145:Don't encrypt publicly accessible website

  bucket           = random_uuid.random_id.id
  website_endpoint = "http://${random_uuid.random_id.id}.s3-website-${var.region}.amazonaws.com"
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend.json
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  #checkov:skip=CKV_AWS_53:Website should be publicly accessible
  #checkov:skip=CKV_AWS_54:Website should be publicly accessible
  #checkov:skip=CKV_AWS_55:Website should be publicly accessible
  #checkov:skip=CKV_AWS_56:Website should be publicly accessible
  
  bucket              = aws_s3_bucket.frontend.id
  block_public_policy = false
}

resource "aws_s3_bucket" "logging" {
  #checkov:skip=CKV_AWS_18:This is the logging bucket
  bucket        = "access-logs-${random_uuid.random_id.id}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_logging" {
  bucket = aws_s3_bucket.logging.bucket
  policy = data.aws_iam_policy_document.bucket_logging.json
}

data "aws_elb_service_account" "main" {}
