# VPCtf 
Name    = "Guestbook"
Region  = "us-east-1"

number_of_AZ            = 2
CIDR                    = "10.0.0.0/16"
public_subnets_cidr     = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24","10.0.5.0/24"]
private_subnets_cidr    = ["10.0.10.0/24","10.0.11.0/24","10.0.12.0/24","10.0.13.0/24","10.0.14.0/24","10.0.15.0/24"]
db_subnets_cidr         = ["10.0.20.0/24","10.0.21.0/24","10.0.22.0/24","10.0.23.0/24","10.0.23.0/24","10.0.24.0/24"]

# Guestbook EC2
key_pair_name = "Global 1"

image_id = "ami-035f992d12130aafb"
instance_type = "t2.micro"
GuestbookEC2RoleName = "EC2GuestbookRole"

env_path = "/var/www/guestbook/.env"

MyDBUsername = "admin"
MyDBPassword = "CHANGEME"
DBName = "guestbook"

AwsCognitoKey = ""
AwsCognitoSecret = ""
AwsCognitoRegion = "us-east-1"
AwsCognitoClientId = "2psfjnipk48fj6k068i7arlkth"
AwsCognitoClientSecret = "ui9703hm0hnm2lgqnmodc1dnf7m7n53v3jgf5ai3pr8mncvm4jf"
AwsCognitoUserPoolId = "us-east-1_vhd2DWiEA"
AwsCognitoDeleteUser = ""