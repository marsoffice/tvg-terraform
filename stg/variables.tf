variable "env" {
  type    = string
  default = "stg"
}

variable "app_name" {
  type    = string
  default = "tvg"
}

variable "domain_name" {
  type    = string
  default = "stg.zikmash.com"
}


variable "app_hostname" {
  type    = string
  default = "app.stg.zikmash.com"
}

variable "publicvapidkey" {
  type      = string
  sensitive = true
}

variable "privatevapidkey" {
  type      = string
  sensitive = true
}

variable "sendgridapikey" {
  type      = string
  sensitive = true
}