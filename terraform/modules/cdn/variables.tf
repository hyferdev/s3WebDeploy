variable "domain_name" {
  type = string
}

variable "domain_aliases" {
  type    = list(string)
  default = []
}

variable "bucket_id" {
  type = string
}

variable "bucket_regional_domain_name" {
  type = string
}

variable "bucket_arn" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "hosted_zone_id" {
  type    = string
  default = ""
}
