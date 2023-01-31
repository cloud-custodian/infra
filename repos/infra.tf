resource "github_repository" "infra" {
  name        = "infra"
  description = "project community infrastructure"
  visibility = "public"

  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  squash_merge_commit_title = "PR_TITLE"
  auto_init = true
  delete_branch_on_merge = true
}



resource "github_branch_protection_v3" "infra_main" {
  repository     = github_repository.infra.name
  branch         = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}
