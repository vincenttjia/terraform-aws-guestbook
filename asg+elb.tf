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

data "template_file" "Guestbook-EC2" {
    template = "${file("${path.module}/scripts/guestbook-EC2.sh")}"

    vars = {
      "env_path" = var.env_path,
      "DbHost" = module.DB_instance.private_dns,
      "DBName" = var.DBName,
      "MyDBUsername" = var.MyDBUsername,
      "MyDBPassword" = var.MyDBPassword,
      "AwsCognitoKey" = "",
      "AwsCognitoSecret" = "",
      "AwsCognitoRegion" = split("_",aws_cognito_user_pool_client.Guestbook_client.user_pool_id)[0],
      "AwsCognitoClientId" = aws_cognito_user_pool_client.Guestbook_client.id,
      "AwsCognitoClientSecret" = aws_cognito_user_pool_client.Guestbook_client.client_secret,
      "AwsCognitoUserPoolId" = aws_cognito_user_pool_client.Guestbook_client.user_pool_id,
      "AwsCognitoDeleteUser" = "",
      "RedisHost" = module.Redis_Instance.private_dns
    }
}

resource "aws_iam_instance_profile" "Guestbook_profile" {
  name = "Guestbook_Profile"
  role = var.GuestbookEC2RoleName
}

resource "aws_launch_configuration" "guestbook_launch_config" {
  name_prefix = "Guestbook_Launch_Config"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  security_groups = [module.WebSG.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.Guestbook_profile.name

  user_data = data.template_file.Guestbook-EC2.rendered

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_policy" "Guestbook_ASG_policy" {
  name                   = "Guestbook_ASG_Policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.Guestbook_ASG.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}


resource "aws_autoscaling_group" "Guestbook_ASG" {
  name                 = "Guestbook_ASG"
  launch_configuration = aws_launch_configuration.guestbook_launch_config.name
  min_size             = 1
  max_size             = 2
  health_check_type    = "ELB"

  vpc_zone_identifier = module.vpc.private_subnets

  force_delete = true

  target_group_arns = [aws_lb_target_group.Guestbook_Target_Group.arn]

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}