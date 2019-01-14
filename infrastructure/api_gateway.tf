resource "aws_api_gateway_rest_api" "crush_bot" {
  name        = "crush_bot"
  description = "The crush bot entrypoint!"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.crush_bot.id}"
  parent_id   = "${aws_api_gateway_rest_api.crush_bot.root_resource_id}"

  path_part = "webhook"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.crush_bot.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.crush_bot.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.reply_euu.invoke_arn}"
}

resource "aws_api_gateway_deployment" "crush_bot" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
  ]

  rest_api_id       = "${aws_api_gateway_rest_api.crush_bot.id}"
  stage_name        = "test"
  stage_description = "${md5(file("api_gateway.tf"))}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.reply_euu.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.crush_bot.execution_arn}/*/*"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.crush_bot.invoke_url}"
}

# logging
resource "aws_api_gateway_account" "gw_account" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatch.arn}"
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = "${aws_iam_role.cloudwatch.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
