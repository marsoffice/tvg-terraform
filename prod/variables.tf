variable "env" {
  type    = string
  default = "prod"
}

variable "app_name" {
  type    = string
  default = "tvg"
}

variable "domain_name" {
  type    = string
  default = "zikmash.com"
}


variable "app_hostname" {
  type    = string
  default = "app.zikmash.com"
}

variable "landing_hostname" {
  type    = string
  default = "landing.zikmash.com"
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

variable "ttclientkey" {
  type = string
  sensitive = true
}

variable "ttclientsecret" {
  type = string
  sensitive = true
}