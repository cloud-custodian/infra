variable "github_repos" {
  type        = list(string)
  description = "list of *full* repo names in the org that should be allowed access to the role"
}


variable "resource_tags" {
  type        = map(any)
  description = "Tags to be applied to all resources."
}


data "aws_iam_policy_document" "ci_access" {
  statement {
    sid = "PublishDocs"
    resources = [
      "arn:aws:s3:::cloudcustodian.io",
      "arn:aws:s3:::cloudcustodian.io/*"
    ]
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
  }

  statement {
    sid = "PublishDocsStage"
    resources = [
      "arn:aws:s3:::docs-stage.cloudcustodian.io",
      "arn:aws:s3:::docs-stage.cloudcustodian.io/*"
    ]
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
  }

}

data "aws_iam_policy_document" "ci_trust" {
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

resource "aws_iam_role" "ci" {
  name               = "ci-github-actions"
  assume_role_policy = data.aws_iam_policy_document.ci_trust.json
  # allow a single session for a max of 70m
  max_session_duration = 4200
}


resource "aws_iam_policy" "ci_access" {
  name        = "oss-ci-access"
  description = "Github Action access within account"
  policy      = data.aws_iam_policy_document.ci_access.json
}


resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  client_id_list  = ["sts.amazonaws.com"]
}


resource "aws_iam_role_policy_attachment" "access" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_access.arn
}
