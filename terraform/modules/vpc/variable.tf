variable "region"{
    type = string
}

variable "public_subnet_cidrs" {
  type    = list(any)
}

variable "private_subnet_cidrs" {
  type    = list(any)
}

variable "availability_zones" {
  type    = list(any)
}