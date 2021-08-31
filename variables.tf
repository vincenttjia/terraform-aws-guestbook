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

variable "image_id" {
    type = string  
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "GuestbookEC2RoleName" {
    type = string
    default = "arn:aws:iam::057766946565:role/EC2GuestbookRole"
}

variable "env_path" {
    type = string
}

variable "MyDBUsername" {
    type = string
}

variable "MyDBPassword" {
    type = string
}

variable "DBName" {
    type = string
}

variable "AwsCognitoKey" {
    type = string
}

variable "AwsCognitoSecret" {
    type = string
}

variable "AwsCognitoRegion" {
    type = string
}

variable "AwsCognitoClientId" {
    type = string
}

variable "AwsCognitoClientSecret" {
    type = string
}

variable "AwsCognitoUserPoolId" {
    type = string
}

variable "AwsCognitoDeleteUser" {
    type = string
}