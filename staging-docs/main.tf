variable "resource_tags" {
  type        = map(any)
  description = "Tags to be applied to all resources."
}

resource "aws_s3_bucket" "docs_stage" {
  bucket = "docs-stage.cloudcustodian.io"
}

resource "aws_s3_bucket_website_configuration" "docs_stage" {
  bucket = aws_s3_bucket.docs_stage.bucket
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "docs_stage" {
  bucket = aws_s3_bucket.docs_stage.id

  rule {
    id = "expiration"

    expiration {
      days = 21
    }

    status = "Enabled"
  }
}

data "aws_iam_policy_document" "docs_stage" {
  statement {
    sid = "PublicAccess"
    resources = [
      "arn:aws:s3:::docs-stage.cloudcustodian.io",
      "arn:aws:s3:::docs-stage.cloudcustodian.io/*"
    ]
    actions = ["s3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


resource "aws_s3_bucket_policy" "docs_stage" {
  bucket = aws_s3_bucket.docs_stage.bucket
  policy = data.aws_iam_policy_document.docs_stage.json
}

data "aws_route53_zone" "docs_stage" {
  name = "cloudcustodian.io."
}

resource "aws_route53_record" "docs_stage" {
  zone_id = data.aws_route53_zone.docs_stage.zone_id
  name    = "docs-stage.cloudcustodian.io"
  type    = "A"
  alias {
    name                   = aws_s3_bucket_website_configuration.docs_stage.website_endpoint
    zone_id                = aws_s3_bucket.docs_stage.hosted_zone_id
    evaluate_target_health = true
  }
}
