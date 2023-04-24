resource "aws_cloudfront_distribution" "this" {

  aliases = [var.website_domain]

  origin {
    domain_name = aws_lb.this.dns_name
    origin_id   = "${var.prefix}-ssr"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      = var.enable_ip_address_blocking ? aws_wafv2_web_acl.this.arn : null

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.prefix}-ssr"
    compress         = true

    cache_policy_id        = data.aws_cloudfront_cache_policy.this.id
    viewer_protocol_policy = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.enable_basic_auth ? [""] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.this.arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.virginia.arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/error.html"
  }
}

resource "aws_cloudfront_function" "this" {
  name    = "${var.prefix}-basic-auth"
  runtime = "cloudfront-js-1.0"
  comment = "This function provides basic authentication."
  publish = true
  code = templatefile("${path.module}/templates/cf_functions/basic_auth.js", {
    user : var.basic_auth_username == null ? var.prefix : var.basic_auth_username,
    pass : aws_ssm_parameter.this.value
  })
}
