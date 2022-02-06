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
  default = "stg.tvg.qoffice.ro"
}


variable "app_hostname" {
  type    = string
  default = "app.stg.tvg.qoffice.ro"
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