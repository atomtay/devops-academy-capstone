resource "aws_iam_instance_profile" "backend_server" {
}

resource "aws_iam_role" "project" {
    assume_role_policy = jsonencode({})
}

data "aws_iam_policy_document" "assume_role" {
}