resource "aws_cloudwatch_log_group" "micronaut-log-group" {
  name              = var.cloudwatch_group
  retention_in_days = 30
}

