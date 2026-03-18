# terraform/main.tf
module "storage" {
  source      = "./modules/storage"
  domain_name = var.domain_name
}

module "cdn" {
  source                      = "./modules/cdn"
  domain_name                 = var.domain_name
  domain_aliases              = var.domain_aliases
  bucket_id                   = module.storage.bucket_id
  bucket_regional_domain_name = module.storage.bucket_regional_domain_name
  bucket_arn                  = module.storage.bucket_arn
  acm_certificate_arn         = var.acm_certificate_arn
  hosted_zone_id              = var.hosted_zone_id
}

module "notifications" {
  source           = "./modules/notifications"
  environment_name = var.environment_name
  domain_name      = var.domain_name
  domain_aliases   = var.domain_aliases
  contact_emails   = var.contact_emails
  hosted_zone_id   = var.hosted_zone_id
  contact_token    = var.contact_token
}
