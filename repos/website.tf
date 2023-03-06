variable "docs_publish_role" {
  type        = string
  description = "arn of aws iam role for doc publishing"
}

resource "github_repository" "website" {
  name        = "www.cloudcustodian.io"
  description = "project website"
  visibility  = "public"

  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  squash_merge_commit_title = "PR_TITLE"
  auto_init                 = true
  delete_branch_on_merge    = true
}


resource "github_actions_secret" "publish_secret" {
  repository      = github_repository.website.name
  secret_name     = "DOC_PUBLISH_ROLE"
  plaintext_value = var.docs_publish_role
}

resource "github_branch_protection_v3" "website_main" {
  repository = github_repository.website.name
  branch     = "main"

  lifecycle {
    ignore_changes = [required_status_checks]
  }
  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  required_status_checks {
    strict = true
    # this app id value has to be inferred manually
    # post initial provisioning and reapplied.
    checks = [
      "Build",
      "Build:1374393172744"
    ]
  }
}


resource "github_team_repository" "website_access_team_aws" {
  team_id    = data.github_team.aws.id
  repository = github_repository.website.name
  permission = "maintain"
}


resource "github_team_repository" "website_access_team_azure" {
  team_id    = data.github_team.azure.id
  repository = github_repository.website.name
  permission = "maintain"
}


resource "github_team_repository" "website_access_team_gcp" {
  team_id    = data.github_team.gcp.id
  repository = github_repository.website.name
  permission = "maintain"
}


