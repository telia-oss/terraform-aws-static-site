# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "website_bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "website_bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}

output "initial_bucket_policy" {
  value = data.aws_iam_policy_document.s3_policy.json
}

output "site_url"{
  value = var.site_name
}