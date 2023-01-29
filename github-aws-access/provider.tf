locals {
  resource_tags = merge(var.resource_tags, { "custodian:component" : "github-actions" })
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.resource_tags
  }
}

terraform {
  backend "s3" {
    bucket = "c7n-terraform-state"
    key    = "tfstate/oss-github"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}