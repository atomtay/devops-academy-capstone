resource "aws_iam_instance_profile" "backend_server" {
  name = "ec2_profile"
  role = aws_iam_role.project.name
}

resource "aws_iam_role" "project" {
  name   = "ec2_role"
  assume_role_policy = <<EOF
{
  "Statement": [
     {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}  
  EOF
}


data "aws_iam_policy_document" "frontend" {
  statement {
    effect        = "Allow"
    actions       = ["s3:GetObject"]
    resources     = ["arn:aws:s3:::${aws_s3_bucket.frontend.bucket}/*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:user/${var.iam_user}"]
    }
  }
}

data "aws_iam_policy_document" "bucket_logging" {
  statement {
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }

  statement {
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.logging.bucket}"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}
