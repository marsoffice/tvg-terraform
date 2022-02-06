variable "name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group" {
    type = string
}

variable "sku_tier" {
    type = string
}

variable "sku_size" {
    type = string
}


variable "properties" {
    type = map(string)
}