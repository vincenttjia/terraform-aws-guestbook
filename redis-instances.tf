data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

data "template_file" "redis" {
    template = "${file("${path.module}/scripts/redis.sh")}"
}

module "Redis_Instance" {
    depends_on = [module.vpc]

    source  = "terraform-aws-modules/ec2-instance/aws"
    name = "Guestbook-Redis"

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"

    subnet_id = module.vpc.private_subnets[0]
    vpc_security_group_ids = [ module.RedisSG.security_group_id ]

    key_name = var.key_pair_name
    user_data = data.template_file.redis.rendered
}

