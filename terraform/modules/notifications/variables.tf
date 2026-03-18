variable "domain_name" {
  type = string
}

variable "contact_emails" {
  type = list(string)
}

variable "hosted_zone_id" {
  type    = string
  default = ""
}

variable "environment_name" {
  type = string
}

variable "domain_aliases" {
  type    = list(string)
  default = []
}

variable "contact_token" {
  type      = string
  sensitive = true
}
