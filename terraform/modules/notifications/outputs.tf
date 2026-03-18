output "function_url" {
  value = aws_lambda_function_url.contact.function_url
}

output "contact_token" {
  value     = var.contact_token
  sensitive = true
}
