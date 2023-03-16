resource "aws_kms_key" "codeartifact" {
  description = "key for codeartifact repo"
}

resource "aws_codeartifact_domain" "release-staging" {
  domain         = "release-staging"
  encryption_key = aws_kms_key.codeartifact.arn
}

resource "aws_codeartifact_repository" "release-staging" {
  domain     = aws_codeartifact_domain.release-staging.domain
  repository = "stagec7n"
  external_connections {
    external_connection_name = "public:pypi"
  }
}

resource "aws_codeartifact_repository_permissions_policy" "release-staging-access" {
  domain          = aws_codeartifact_domain.release-staging.domain
  repository      = aws_codeartifact_repository.release-staging.repository
  policy_document = file("staging-policy.json")
}

