resource "aws_wafv2_ip_set" "this" {
  provider = aws.virginia

  name               = "${var.prefix}-${replace(var.ecs_cluster_name, ".", "-")}"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ip_addresses
}

resource "aws_wafv2_web_acl" "this" {
  provider = aws.virginia

  name  = "${var.prefix}-${replace(var.ecs_cluster_name, ".", "-")}"
  scope = "CLOUDFRONT"

  custom_response_body {
    key          = "access-denied"
    content      = "Access denied."
    content_type = "TEXT_PLAIN"
  }

  default_action {
    block {
      custom_response {
        response_code            = 401
        custom_response_body_key = "access-denied"
      }
    }
  }

  rule {
    name     = "allow-if-ip-address-matched"
    priority = 5

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.this.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "metric-name"
    sampled_requests_enabled   = false
  }
}
