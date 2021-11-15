resource "aws_db_instance" "Guestbook_RDS" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.small"
  name                 = "GuestbookRDS"
  username             = var.MyDBUsername
  password             = var.MyDBPassword
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = module.vpc.database_subnet_group_name
}

# data "template_file" "mysql" {
#     template = "${file("${path.module}/scripts/mysql.sh")}"

#     vars = {
#       "DBName" = var.DBName,
#       "MyDBUsername" = var.MyDBUsername,
#       "MyDBPassword" = var.MyDBPassword
#     }
# }

# module "DB_instance" {
#     source  = "terraform-aws-modules/ec2-instance/aws"
#     name = "Guestbook-DB"

#     ami = data.aws_ami.ubuntu.id
#     instance_type = "t2.micro"

#     subnet_id = module.vpc.private_subnets[0]
#     vpc_security_group_ids = [ module.DBSG.security_group_id ]

#     key_name = var.key_pair_name
#     user_data = data.template_file.mysql.rendered
# }