resource "aws_acm_certificate" "virginia" {
  provider = aws.virginia

  domain_name               = var.hosted_zone_domain
  subject_alternative_names = [var.website_domain]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "virginia" {
  provider = aws.virginia

  certificate_arn         = aws_acm_certificate.virginia.arn
  validation_record_fqdns = [for record in aws_route53_record.virginia : record.fqdn]
}
