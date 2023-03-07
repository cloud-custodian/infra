resource "github_repository" "infra" {
  name        = "infra"
  description = "project community infrastructure"
  visibility  = "public"

  allow_merge_commit        = false
  allow_rebase_merge        = false
  allow_squash_merge        = true
  has_issues                = true
  squash_merge_commit_title = "PR_TITLE"
  auto_init                 = true
  delete_branch_on_merge    = true
}



resource "github_branch_protection_v3" "infra_main" {
  repository = github_repository.infra.name
  branch     = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}



resource "github_team_repository" "infra_access_team_aws" {
  team_id    = data.github_team.aws.id
  repository = github_repository.infra.name
  permission = "maintain"
}


resource "github_team_repository" "infra_access_team_azure" {
  team_id    = data.github_team.azure.id
  repository = github_repository.infra.name
  permission = "maintain"
}


resource "github_team_repository" "infra_access_team_gcp" {
  team_id    = data.github_team.gcp.id
  repository = github_repository.infra.name
  permission = "maintain"
}

