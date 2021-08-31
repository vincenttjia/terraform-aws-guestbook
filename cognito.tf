resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "Guestbook_Auto_Verify_Cognito" {
    filename      = "${path.module}/lambda/cognito_lambda.zip"
    function_name = "GuestbookAutoVerifyCognito"
    handler       = "index.handler"
    role          = aws_iam_role.iam_for_lambda.arn

    source_code_hash = filebase64sha256("${path.module}/lambda/cognito_lambda.zip")

    runtime = "nodejs12.x"
}

resource "aws_lambda_permission" "allow_cognito" {
    statement_id  = "AllowExecutionFromCognitoUserpool"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.Guestbook_Auto_Verify_Cognito.function_name
    principal     = "cognito-idp.amazonaws.com"
}

resource "aws_cognito_user_pool" "Guestbook_User_Pool" {
    name = "Guestbook-Userpool"

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }
    }

    lambda_config {
        pre_sign_up = aws_lambda_function.Guestbook_Auto_Verify_Cognito.arn
    }
}


resource "aws_cognito_user_pool_client" "Guestbook_client" {
    name = "Guestbook-client"

    generate_secret     = true
    user_pool_id = aws_cognito_user_pool.Guestbook_User_Pool.id
    explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH","ALLOW_ADMIN_USER_PASSWORD_AUTH","ALLOW_USER_PASSWORD_AUTH","ALLOW_USER_SRP_AUTH"]
}