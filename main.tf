provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

resource "aws_cloudfront_function" "any_site_basic_auth" {
  name    = "any-site-basic-auth"
  runtime = "cloudfront-js-1.0"
  comment = "Basic authentication function"
  publish = true
  code    = file("${path.root}/basic_auth.js")

}


module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  comment                       = "CloudFront Resource"
  enabled                       = true
  is_ipv6_enabled               = true
  price_class                   = "PriceClass_All"
  retain_on_delete              = false
  wait_for_deployment           = false
  default_root_object           = "index.html"
  create_origin_access_identity = true

  logging_config = {
    bucket = module.s3_any_site_cloudfront_access_log.s3_bucket_bucket_regional_domain_name
  }
  origin_access_identities = {
    s3_bucket = module.s3_any_site_bucket.s3_bucket_id
  }
  origin = {
    site = {
      domain_name              = module.s3_any_site_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.any_site_cloudfront_oac.id
    }
  }
  default_cache_behavior = {
    target_origin_id       = "site"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    function_association = {
      # Valid keys: viewer-request, origin-request, viewer-response, origin-response
      viewer-request = {
        function_arn = aws_cloudfront_function.any_site_basic_auth.arn
      }
    }
  }
}

resource "aws_cloudfront_origin_access_control" "any_site_cloudfront_oac" {
  name                              = "any-site-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "s3_any_site_bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_any_site_bucket.s3_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"

      # FIXME:
      #     Write ARN directly to avoid circular importing, but it's not simple and beautiful. Consider elegant way.
      values = ["<cloudfront-arn>"]
    }
  }
}

module "s3_any_site_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "any-site-${terraform.workspace}-bucket"
  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_any_site_bucket_policy.json
}

module "s3_any_site_cloudfront_access_log" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "any-site-${terraform.workspace}-cloudfront-access-log"
}
