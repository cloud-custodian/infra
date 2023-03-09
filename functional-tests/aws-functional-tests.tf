data "aws_iam_policy_document" "ftest_ci_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.github_repos
    }
  }
}

resource "aws_iam_role" "ftest_ci" {
  name               = "ftest-ci-github-actions"
  assume_role_policy = data.aws_iam_policy_document.ftest_ci_trust.json
  # allow a single session for a max of 70m
  max_session_duration = 4200
}

data "aws_iam_policy" "power_user" {
  name = "PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "ftest_power_user_access" {
  role       = aws_iam_role.ftest_ci.name
  policy_arn = data.aws_iam_policy.power_user.arn
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  client_id_list  = ["sts.amazonaws.com"]
}


