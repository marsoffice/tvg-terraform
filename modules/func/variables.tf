variable "name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group" {
    type = string
}


variable "storage_account_name" {
    type = string
}

variable "storage_account_access_key" {
    type = string
}

variable "app_service_plan_id" {
    type = string
}

variable "kvl_id" {
    type = string
}

variable "app_configs" {
    type = map(string)
}

variable "ad_application_id" {
    type = string
}

variable "ad_application_object_id" {
    type = string
}

variable "ad_application_secret" {
    type = string
    sensitive = true
}

variable "ad_audience" {
    type = string
}

variable "ad_issuer" {
    type = string
}

variable "appi_instrumentation_key" {
    type = string
}

variable "func_env" {
    type = string
}

variable "internal_role_id" {
    type = string
}

variable "roles" {
    type = list(string)
}
