### CLOUDWATCH ###

resource "aws_iam_role" "cloudwatch" {
  name = "api-gateway-cloudwatch"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "apigateway.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "cloudwatch-default"
  role = aws_iam_role.cloudwatch.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
          ],
          "Resource" : "*"
        }
      ]
  })
}

### LAMBDA ###

resource "aws_iam_role" "api_lambda_role" {
  name = "api-lambda-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })
}

### LAMBDA ###

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda-logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
