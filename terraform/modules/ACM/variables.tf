variable "domain_name" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}

variable "private_zone" {
  type = bool
}

variable "cert_validation_ttl" {
  type = number
}