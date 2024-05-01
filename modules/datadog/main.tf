resource "aws_lambda_function" "datadog_forwarder" {
    function_name = "${var.identifier}_datadog_forwarder_${var.resource_name}"
    description = "Sends resource logs to the datadog"
    role = var.lambda_execution_role
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    filename = "${path.module}/functions/aws-dd-forwarder-3.97.0.zip"
    source_code_hash = filebase64sha256("${path.module}/functions/aws-dd-forwarder-3.97.0.zip") 
    environment {
      variables = var.lambda_environment_variables
  }
}

resource "aws_lambda_permission" "CloudWatchLogsPermission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.datadog_forwarder.arn
  principal     = "logs.amazonaws.com"
}

resource "aws_cloudwatch_log_subscription_filter" "ltk_encompdev_log_subscription_filter" {
  name            = "${var.identifier}_datadog_subscription_filter"
  log_group_name  = var.log_group_configuration
  filter_pattern  = "" 
  destination_arn = aws_lambda_function.datadog_forwarder.arn
}