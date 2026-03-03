variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "target_port" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "health_check_matcher" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "record_name" {
  type = string
}

variable "record_type" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

