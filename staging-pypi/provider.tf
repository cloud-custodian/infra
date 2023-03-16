locals {
  resource_tags = merge(var.resource_tags, { "custodian:component" : "staging-pypi" })
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.resource_tags
  }
}

terraform {
  backend "s3" {
    bucket = "cncf-c7n-tfstate"
    key    = "tfstate/staging-pypi"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}
