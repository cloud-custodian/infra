locals {
  resource_tags = merge(var.resource_tags, { "custodian:component" : "docs-staging" })
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
    key    = "tfstate/docs-stage"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}
