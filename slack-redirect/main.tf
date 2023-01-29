variable "resource_tags" {
  type        = map(any)
  description = "Tags to be applied to all resources."
}

resource "aws_s3_bucket" "slack_redirect" {
  bucket = "slack.cloudcustodian.io"
}

data "aws_iam_policy_document" "slack_redirect" {
  statement {
    sid = "PublicAccess"
    resources = [
      "arn:aws:s3:::slack.cloudcustodian.io",
      "arn:aws:s3:::slack.cloudcustodian.io/*"
    ]
    actions = ["s3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "slack_redirect" {
  bucket = aws_s3_bucket.slack_redirect.bucket
  index_document {
    suffix = "index.html"
  }
  routing_rule {
    redirect {
      host_name        = "communityinviter.com"
      protocol         = "https"
      replace_key_with = "apps/cloud-custodian/c7n-chat"
    }
  }
}

resource "aws_s3_bucket_policy" "slack_redirect" {
  bucket = aws_s3_bucket.slack_redirect.bucket
  policy = data.aws_iam_policy_document.slack_redirect.json
}

data "aws_route53_zone" "slack_redirect" {
  name = "cloudcustodian.io."
}

resource "aws_route53_record" "slack_redirect" {
  zone_id = data.aws_route53_zone.slack_redirect.zone_id
  name    = "slack.cloudcustodian.io"
  type    = "A"
  alias {
    name                   = aws_s3_bucket_website_configuration.slack_redirect.website_endpoint
    zone_id                = aws_s3_bucket.slack_redirect.hosted_zone_id
    evaluate_target_health = true
  }
}
