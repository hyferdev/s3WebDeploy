# terraform/variables.tf
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for S3, Lambda, and API Gateway"
}

variable "environment_name" {
  type    = string
  default = "production"
}

variable "domain_name" {
  type        = string
  description = "Primary domain (e.g. hyfer.com)"
}

variable "domain_aliases" {
  type        = list(string)
  default     = []
  description = "Additional domain aliases (e.g. www.hyfer.com)"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of ACM certificate in us-east-1 (required for CloudFront)"
}

variable "contact_emails" {
  type        = list(string)
  description = "Destination email addresses for contact form submissions (set in TFC)"
}

variable "hosted_zone_id" {
  type        = string
  default     = ""
  description = "Optional: Route53 hosted zone ID (bypasses name lookup if set)"
}

variable "contact_token" {
  type        = string
  sensitive   = true
  description = "Secret token for contact form authentication (set in TFC)"
}
