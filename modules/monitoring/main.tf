module "ecs_high_cpu" {
  source   = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version  = "~> 3.0"
  for_each = toset(var.services)

  alarm_name          = "ecs-high-cpu-${each.key}"
  alarm_description   = "ECS CPU Utilization is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = var.thresholds.cpu_utilization_threshold
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"
  statistic   = "Maximum"

  dimensions = {
    ServiceName = each.key
  }

  alarm_actions = [aws_sns_topic.ecs_updates.arn]

  tags = var.tags
}

module "ecs_high_memory" {
  source   = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version  = "~> 3.0"
  for_each = toset(var.services)

  alarm_name          = "ecs-high-memory-${each.key}"
  alarm_description   = "ECS Memory Utilization is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = var.thresholds.memory_threshold
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"
  statistic   = "Maximum"

  dimensions = {
    ServiceName = each.key
  }

  alarm_actions = [aws_sns_topic.ecs_updates.arn]

  tags = var.tags
}

module "alb_high_httpcode_5xx_count" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  count   = length(var.alb_ids)

  alarm_name          = "alb-high-5XX-count-${var.alb_ids[count.index]}"
  alarm_description   = "ALB HTTP Code 5XX code count is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = var.thresholds.httpcode_5xx_count_threshold
  period              = 60
  unit                = "Count"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"
  statistic   = "Sum"

  dimensions = {
    LoadBalancer = var.alb_ids[count.index]
  }

  alarm_actions = [aws_sns_topic.alb_updates.arn]

  tags = var.tags
}

module "alb_high_httpcode_target_5xx_count" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  count   = length(var.alb_ids)

  alarm_name          = "alb-high-target-5XX-count-${var.alb_ids[count.index]}"
  alarm_description   = "ALB HTTP Code Target 5XX code count is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = var.thresholds.httpcode_target_5xx_count_threshold
  period              = 60
  unit                = "Count"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"
  statistic   = "Sum"

  dimensions = {
    LoadBalancer = var.alb_ids[count.index]
  }

  alarm_actions = [aws_sns_topic.alb_updates.arn]

  tags = var.tags
}

module "alb_high_latency" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  count   = length(var.alb_ids)

  alarm_name          = "alb-high-latency-${var.alb_ids[count.index]}"
  alarm_description   = "ALB Latency is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = 100
  period              = 60
  unit                = "Seconds"

  namespace   = "AWS/ApplicationELB"
  metric_name = "TargetResponseTime"
  statistic   = "Average"

  dimensions = {
    LoadBalancer = var.alb_ids[count.index]
  }

  alarm_actions = [aws_sns_topic.alb_updates.arn]

  tags = var.tags
}

module "alb_high_rejected_connections_count" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  count   = length(var.alb_ids)

  alarm_name          = "alb-high-rejected-connections-count-${var.alb_ids[count.index]}"
  alarm_description   = "ALB rejected connections count is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = var.thresholds.rejected_connection_count_threshold
  period              = 60
  unit                = "Count"

  namespace   = "AWS/ApplicationELB"
  metric_name = "RejectedConnectionCount"
  statistic   = "Sum"

  dimensions = {
    LoadBalancer = var.alb_ids[count.index]
  }

  alarm_actions = [aws_sns_topic.alb_updates.arn]

  tags = var.tags
}

resource "aws_sns_topic" "ecs_updates" {
  name = "ecs-updates-topic"
  tags = var.tags
}

resource "aws_sns_topic" "alb_updates" {
  name = "alb-updates-topic"
  tags = var.tags
}