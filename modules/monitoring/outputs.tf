output "monitoring_outputs" {
  value = {
    ecs_sns_topic = aws_sns_topic.ecs_updates
    alb_sns_topic = aws_sns_topic.alb_updates
  }
}