resource "aws_s3_bucket" "crush_lambda_deployment" {
  bucket = "crush-lambda-deployment"
  acl = "private"
}

resource "aws_lambda_function" "reply_euu" {
  function_name = "reply_euu"

  s3_bucket = "${aws_s3_bucket.crush_lambda_deployment.id}"
  s3_key    = "lambda.zip"

  handler = "main.handler"
  runtime = "nodejs6.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"

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