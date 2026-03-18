# terraform/outputs.tf
output "lambda_function_url" {
  value       = module.notifications.function_url
  description = "Lambda function URL for the contact form"
}

output "contact_token" {
  value       = module.notifications.contact_token
  sensitive   = true
  description = "Secret token injected into landing.js for contact form auth"
}

output "s3_bucket" {
  value       = module.storage.bucket_id
  description = "S3 bucket hosting the static frontend"
}

output "cloudfront_domain" {
  value       = module.cdn.cloudfront_domain
  description = "CloudFront distribution domain name"
}

output "region" {
  value       = var.aws_region
  description = "AWS region of the deployment"
}
