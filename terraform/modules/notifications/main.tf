resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_ses_email_identity" "recipients" {
  for_each = toset(var.contact_emails)
  email    = each.value
}

locals {
  domain_parts = split(".", var.domain_name)
  apex_domain  = join(".", slice(local.domain_parts, length(local.domain_parts) - 2, length(local.domain_parts)))
  zone_id      = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.main[0].zone_id
}

data "aws_route53_zone" "main" {
  count        = var.hosted_zone_id == "" ? 1 : 0
  name         = local.apex_domain
  private_zone = false
}

resource "aws_route53_record" "ses_verification" {
  zone_id = local.zone_id
  name    = "_amazonses.${var.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/contact.mjs"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "contact" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "hyfer_contact_form_${var.environment_name}"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "contact.handler"
  runtime          = "nodejs22.x"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      SOURCE_EMAIL  = "noreply@${var.domain_name}"
      DEST_EMAILS   = join(",", var.contact_emails)
      CONTACT_TOKEN = var.contact_token
    }
  }
}

resource "aws_lambda_function_url" "contact" {
  function_name      = aws_lambda_function.contact.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = concat(
      ["https://${var.domain_name}"],
      [for alias in var.domain_aliases : "https://${alias}"]
    )
    allow_methods = ["POST"]
    allow_headers = ["content-type", "x-contact-token"]
    max_age       = 86400
  }
}
