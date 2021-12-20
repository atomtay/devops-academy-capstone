variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_repo" {
  type    = string
  default = "devops-academy-capstone"
}

variable "github_user" {
  type = string
  default = "atomtay"
}

variable "access_key" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "iam_user" {
  type      = string
  sensitive = true
}

variable "project_name" {
  type    = string
  default = "todo"
}

variable "aws_ec2_username" {
  type    = string
  default = "ubuntu"
}

variable "aws_tags" {
  type = object({
    app = string
  })
  default = {
    app = "todo"
  }
}

