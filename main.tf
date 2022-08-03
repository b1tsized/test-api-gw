### API GATEWAY ###

resource "aws_api_gateway_rest_api" "api_gw_test" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "api_gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_test.id
  parent_id   = aws_api_gateway_rest_api.api_gw_test.root_resource_id
  path_part   = "pets"
}

resource "aws_api_gateway_method" "api_gw_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw_test.id
  resource_id   = aws_api_gateway_resource.api_gw_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_settings" "api_gw_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_test.id
  stage_name  = aws_api_gateway_stage.api_gw_stage.stage_name
  method_path = "*/*"

  settings {
    data_trace_enabled = true
    logging_level      = "ERROR"
  }
}

resource "aws_api_gateway_integration" "api_gw_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gw_test.id
  resource_id             = aws_api_gateway_resource.api_gw_resource.id
  http_method             = aws_api_gateway_method.api_gw_method.http_method
  type                    = "HTTP"
  integration_http_method = aws_api_gateway_method.api_gw_method.http_method
  uri                     = "https://httpstat.us/200"
  depends_on = [
    aws_api_gateway_method.api_gw_method
  ]
}

resource "aws_api_gateway_method_response" "api_gw_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_test.id
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  http_method = aws_api_gateway_method.api_gw_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "api_gw_method_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_test.id
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  http_method = aws_api_gateway_integration.api_gw_method_integration.http_method
  status_code = aws_api_gateway_method_response.api_gw_method_response.status_code
  depends_on = [
    aws_api_gateway_integration.api_gw_method_integration
  ]
}

resource "aws_api_gateway_deployment" "api_gw_stage_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_test.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gw_resource.id,
      aws_api_gateway_method.api_gw_method.id,
      aws_api_gateway_integration.api_gw_method_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gw_stage" {
  deployment_id = aws_api_gateway_deployment.api_gw_stage_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw_test.id
  stage_name    = var.rest_api_name
}

resource "aws_api_gateway_account" "api_gw_account" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

### LAMBDA ###

resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_function.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.api_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

resource "local_file" "lambda_python" {
  content  = templatefile("${path.module}/template/python/lambda_function.tftpl", { HTTP_PORT = "${var.port}", AWS_ADDRESS = "${aws_instance.linux_instance.public_ip}" })
  filename = "${path.module}/python/lambda_function.py"
}

resource "aws_lambda_permission" "cloudwatch_lambda_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.log_group.arn}:*"
}

### CLOUDWATCH ###

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api_gw_test.id}/${var.rest_api_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_subscription_filter" "log_sub_filter" {
  name            = "test_lambdafunction_logfilter"
  log_group_name  = aws_cloudwatch_log_group.log_group.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.lambda.arn
}
