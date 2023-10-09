variable "elestio_email" {
  type = string
}

variable "elestio_api_token" {
  type      = string
  sensitive = true
}

variable "mysql_pass" {
  type      = string
  sensitive = true
}
