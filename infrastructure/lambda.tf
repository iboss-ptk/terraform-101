resource "aws_s3_bucket" "crush_lambda_deployment" {
  bucket = "crush-lambda-deployment"
  acl    = "private"
}

resource "aws_lambda_function" "reply_euu" {
  function_name = "reply_euu"

  s3_bucket = "${aws_s3_bucket.crush_lambda_deployment.id}"
  s3_key    = "lambda.zip"

  source_code_hash = "${base64sha256(file("../deployment/lambda.zip"))}"

  handler = "provided"
  runtime = "provided"

  role = "${aws_iam_role.lambda_exec.arn}"

  environment {
    variables {
      CHANNEL_ACCESS_TOKEN = "${var.channel_access_token}"
    }
  }
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

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_logging_policy_to_lambda_exec_role" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
