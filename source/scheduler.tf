# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "instance_scheduler_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "instance_scheduler_lambda_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [for account_id in values(var.target_accounts) :
          "arn:aws:iam::${account_id}:role/TargetInstanceSchedulerRole"
        ]
      }
    ]
  })
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/InstanceSchedulerFunction"
  retention_in_days = 3
}

# Lambda Function
resource "aws_lambda_function" "scheduler_lambda" {
  filename         = "lambda_deployment_package.zip"
  function_name    = "InstanceSchedulerFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "power_manager.lambda_handler"
  source_code_hash = filebase64sha256("power_manager_package.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      SCHEDULES       = jsonencode(var.schedules)
      PERIODS         = jsonencode(var.periods)
      TARGET_ACCOUNTS = jsonencode(var.target_accounts)
      AWS_REGIONS     = jsonencode(var.regions)
    }
  }

  timeout     = 300
  memory_size = 128

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}


# CloudWatch Event Rule for Start (Configurable Start Time)
resource "aws_cloudwatch_event_rule" "scheduler_start_rule" {
  name                = "InstanceSchedulerStartRule"
  schedule_expression = "cron(0 ${local.start_time_utc} * * ? *)"
  description         = "Triggers the instance scheduler Lambda function at the configured start time (UTC ${local.start_time_utc}) daily"
}

# CloudWatch Event Rule for Stop (Configurable Stop Time)
resource "aws_cloudwatch_event_rule" "scheduler_stop_rule" {
  name                = "InstanceSchedulerStopRule"
  schedule_expression = "cron(0 ${local.stop_time_utc} * * ? *)"
  description         = "Triggers the instance scheduler Lambda function at the configured stop time (UTC ${local.stop_time_utc}) daily"
}

# CloudWatch Event Target for Start Event
resource "aws_cloudwatch_event_target" "start_lambda_target" {
  rule  = aws_cloudwatch_event_rule.scheduler_start_rule.name
  arn   = aws_lambda_function.scheduler_lambda.arn
  input = jsonencode({ action = "check" })
}

# CloudWatch Event Target for Stop Event
resource "aws_cloudwatch_event_target" "stop_lambda_target" {
  rule  = aws_cloudwatch_event_rule.scheduler_stop_rule.name
  arn   = aws_lambda_function.scheduler_lambda.arn
  input = jsonencode({ action = "check" })
}

# Lambda Permission for CloudWatch Event (Start Event)
resource "aws_lambda_permission" "allow_cloudwatch_to_call_scheduler_start" {
  statement_id  = "AllowExecutionFromCloudWatchStartInstances"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduler_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler_start_rule.arn
}

# Lambda Permission for CloudWatch Event (Stop Event)
resource "aws_lambda_permission" "allow_cloudwatch_to_call_scheduler_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStopInstances"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduler_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler_stop_rule.arn
}
