module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "${var.Name}-VPC"
    cidr = var.CIDR

    enable_dns_hostnames = true

    azs = slice(formatlist("%s%s",local.region,var.AZ_mapping),0,var.number_of_AZ)

    public_subnets = slice(var.public_subnets_cidr,0,var.number_of_AZ)
    private_subnets = slice(var.private_subnets_cidr,0,var.number_of_AZ)
    database_subnets = slice(var.db_subnets_cidr,0,var.number_of_AZ)

    enable_nat_gateway = true

}


module "WebELBSG" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "WebELBSG"
    description = "Allow HTTP and HTTPS from Anywhere"
    vpc_id      = module.vpc.vpc_id

    ingress_with_cidr_blocks = [{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    },
    {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }]

    ingress_with_ipv6_cidr_blocks = [{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        ipv6_cidr_blocks = "::/0"
    },
    {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        ipv6_cidr_blocks = "::/0"
    }]

    egress_with_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = "0.0.0.0/0"
    }]

    egress_with_ipv6_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = "::/0"
    }]
}

module "WebSG" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "WebSG"
    description = "Allow HTTP and HTTPS from WebELBSG"
    vpc_id      = module.vpc.vpc_id


    computed_ingress_with_source_security_group_id = [
    {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        source_security_group_id = module.WebELBSG.security_group_id
    },
    {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        source_security_group_id = module.WebELBSG.security_group_id
    }
    ]
    number_of_computed_ingress_with_source_security_group_id = 2

    egress_with_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = "0.0.0.0/0"
    }]

    egress_with_ipv6_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = "::/0"
    }]
}

module "RedisSG" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "RedisSG"
    description = "Allow Redis traffic From WebSG"
    vpc_id      = module.vpc.vpc_id


    computed_ingress_with_source_security_group_id = [
    {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        source_security_group_id = module.WebSG.security_group_id
    }
    ]
    number_of_computed_ingress_with_source_security_group_id = 1

    egress_with_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = "0.0.0.0/0"
    }]

    egress_with_ipv6_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = "::/0"
    }]
}

module "DBSG" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "DBSG"
    description = "Allow DB traffic From WebSG"
    vpc_id      = module.vpc.vpc_id


    computed_ingress_with_source_security_group_id = [
    {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        source_security_group_id = module.WebSG.security_group_id
    }
    ]
    number_of_computed_ingress_with_source_security_group_id = 1

    egress_with_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = "0.0.0.0/0"
    }]

    egress_with_ipv6_cidr_blocks = [{
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = "::/0"
    }]
}