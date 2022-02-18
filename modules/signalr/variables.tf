variable "name" {
    type = string
}

variable "resource_group" {
    type = string
}

variable "location" {
    type = string
}

variable "sku" {
    type = string
}

variable "capacity" {
    type = number
}

variable "allow_localhost" {
    type = bool
}

variable "allowed_host" {
    type = string
}