data "aws_route53_zone" "this" {
  name = "${var.hosted_zone_domain}."
}
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}
