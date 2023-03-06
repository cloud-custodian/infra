
# Configure the GitHub Provider
provider "github" {
  owner = "cloud-custodian"
}

terraform {
  backend "s3" {
    bucket = "c7n-terraform-state"
    key    = "tfstate/oss-github-repos"
    region = "us-east-1"
  }
}