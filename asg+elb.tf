resource "aws_lb" "Guestbook_ALB" {
  name               = "Guestbook-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.WebELBSG.security_group_id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "Guestbook_Target_Group" {
  name     = "Guestbook-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Guestbook_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Guestbook_Target_Group.arn
  }
}

resource "aws_launch_configuration" "guestbook_launch_config" {
  name          = "Guestbook_Launch_Config"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  security_groups = [module.WebSG.security_group_id]
}


resource "aws_autoscaling_group" "Guestbook_ASG" {
  name                 = "Guestbook_ASG"
  launch_configuration = aws_launch_configuration.guestbook_launch_config.name
  min_size             = 1
  max_size             = 2
  desired_capacity      = 1

  vpc_zone_identifier = module.vpc.private_subnets

  force_delete = true

  target_group_arns = [aws_lb_target_group.Guestbook_Target_Group.arn]

}