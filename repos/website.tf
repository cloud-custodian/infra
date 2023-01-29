resource "github_repository" "website" {
  name        = "www.cloudcustodian.io"
  description = "project website"
  visibility = "public"

  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  squash_merge_commit_title = "PR_TITLE"
  auto_init = true
  delete_branch_on_merge = true
}


resource "github_actions_secret" "publish_secret" {
  repository       = github_repository.website.name
  secret_name      = "DOC_PUBLISH_ROLE"
  plaintext_value  = "arn:aws:iam::619193117841:role/ci-github-actions"
}

resource "github_branch_protection_v3" "website_main" {
  repository     = github_repository.website.name
  branch         = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
  
  required_status_checks {
    strict   = true
    checks = [
      "CI/Build"
    ]
  }
}
