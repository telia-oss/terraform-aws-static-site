# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
provider "aws" {
  region  = "us-east-1"
  alias   = "virginia"
  version = "~> 2.23"
}

resource "aws_acm_certificate" "cert_website" {
  domain_name       = var.site_name
  validation_method = "DNS"
  provider          = aws.virginia
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "main" {
  name = var.hosted_zone_name
}

resource "aws_route53_record" "cert_website_validation" {
  name    = aws_acm_certificate.cert_website.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert_website.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.main.id
  records = [aws_acm_certificate.cert_website.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.cert_website.arn
  validation_record_fqdns = [aws_route53_record.cert_website_validation.fqdn]
  provider                = aws.virginia
}

resource "aws_s3_bucket" "website_bucket" {
  bucket_prefix = "${var.name_prefix}-static-website-bucket"
  acl           = "private"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled = var.bucket_versioning
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin access identity for s3/cloudfront"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [
    aws_s3_bucket.website_bucket,
    aws_acm_certificate_validation.main,
  ]

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = aws_cloudfront_origin_access_identity.origin_access_identity.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [aws_acm_certificate.cert_website.domain_name]

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = aws_cloudfront_origin_access_identity.origin_access_identity.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert_website.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "wwww_a" {
  name    = "${var.site_name}."
  type    = "A"
  zone_id = data.aws_route53_zone.main.id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

