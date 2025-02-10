provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "current_time_lambda" {
  function_name = "FetchCurrentTime"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_execution_role.arn

  filename      = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}
