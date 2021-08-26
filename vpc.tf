module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "${var.Name}-VPC"
    cidr = var.CIDR

    azs = slice(formatlist("%s%s",local.region,var.AZ_mapping),0,var.number_of_AZ)

    public_subnets = slice(var.public_subnets_cidr,0,var.number_of_AZ)
    private_subnets = slice(var.private_subnets_cidr,0,var.number_of_AZ)
    database_subnets = slice(var.db_subnets_cidr,0,var.number_of_AZ)

    enable_nat_gateway = true

}