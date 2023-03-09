variable "ftest_aws_role" {
  type        = string
  description = "arn of aws iam role for functional testing"
}

variable "ci_slack_webhook" {
  type        = string
  description = "slack webhook for ci notifications"
}

data "github_repository" "c7n" {
  full_name = "cloud-custodian/cloud-custodian"
}

resource "github_actions_secret" "ftest_aws_secret" {
  repository      = data.github_repository.c7n.name
  secret_name     = "AWS_FTEST_ROLE"
  plaintext_value = var.ftest_aws_role
}

resource "github_actions_secret" "ci_slack_secret" {
  repository      = data.github_repository.c7n.name
  secret_name     = "SLACK_CI_HOOK"
  plaintext_value = var.ci_slack_webhook
}


