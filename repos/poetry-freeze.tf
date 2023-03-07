variable "freeze_release_token" {
  type        = string
  description = "arn of aws iam role for doc publishing"
}

resource "github_repository" "poetry_freeze" {
  name        = "poetry-plugin-freeze"
  description = "poetry plugin to freeze wheels"
  visibility  = "public"
  topics = [
    "poetry",
    "poetry-plugin",
    "poetry-python",
  ]
  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true
  has_issues = true
  squash_merge_commit_title = "PR_TITLE"
  auto_init                 = true
  delete_branch_on_merge    = true
}



resource "github_branch_protection_v3" "poetry_freeze" {
  repository = github_repository.poetry_freeze.name
  branch     = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}


resource "github_actions_secret" "publish_freeze_secret" {
  repository      = github_repository.poetry_freeze.name
  secret_name     = "PYPI_TOKEN"
  plaintext_value = var.freeze_release_token
}


resource "github_team_repository" "poetry_freeze_access_team_aws" {
  team_id    = data.github_team.aws.id
  repository = github_repository.poetry_freeze.name
  permission = "maintain"
}


resource "github_team_repository" "poetry_freeze_access_team_azure" {
  team_id    = data.github_team.azure.id
  repository = github_repository.poetry_freeze.name
  permission = "maintain"
}


resource "github_team_repository" "poetry_freeze_access_team_gcp" {
  team_id    = data.github_team.gcp.id
  repository = github_repository.poetry_freeze.name
  permission = "maintain"
}
