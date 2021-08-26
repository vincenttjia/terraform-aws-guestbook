variable "Name" {
    type = string
}

variable "key_pair_name" {
    type = string
}

variable "Region" {
    type = string
}

variable "CIDR" {
    type = string
}

variable "AZ_mapping" {
    type = list
    default = ["a","b","c","d","e","f"]
}

variable "public_subnets_cidr" {
    type = list
}

variable "private_subnets_cidr" {
    type = list
}

variable "db_subnets_cidr" {
    type = list
}

variable "number_of_AZ" {
    type = number
    default = 2

    validation {
        condition     = var.number_of_AZ>0 && var.number_of_AZ<=6
        error_message = "The Number of AZ must be between 1 and 6."
    }
}