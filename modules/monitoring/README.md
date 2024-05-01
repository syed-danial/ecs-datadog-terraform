# Monitoring module

This module creates alerts for the ECS and ALB resources, as well as an SNS topic to push to as an alarm action. The alert
thresholds are configurable and the alerts currently included with this module are:
* ECS:
  * High CPU Utilization
  * High Memory Utilization
* ALB:
  * High HTTP Code 5XX Count
  * High HTTP Code Target 5XX Count
  * High Latency
  * High Rejected Connections Count

<!-- BEGIN_TF_DOCS -->
## Modules

| Name                                                                                                                                                  | Source                                                             | Version |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|---------|
| <a name="module_ecs_high_cpu"></a> [ecs\_high\_cpu](#module\_ecs\_high\_cpu)                                                                          | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |
| <a name="module_ecs_high_memory"></a> [ecs\_high\_memory](#module\_ecs\_high\_memory)                                                                 | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |
| <a name="module_alb_high_httpcode_5xx_count"></a> [alb\_high\_httpcode\_5xx\_count](#module\_alb\_high\_httpcode\_5xx\_count)                         | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |
| <a name="module_alb_high_httpcode_target_5xx_count"></a> [alb\_high\_httpcode\_target\_5xx\_count](#module\_alb\_high\_httpcode\_target\_5xx\_count)  | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |
| <a name="module_alb_high_latency"></a> [alb\_high\_latency](#module\_alb\_high\_latency)                                                              | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |
| <a name="module_alb_high_rejected_connections_count"></a> [alb\_high\_rejected\_connections\_count](#module\_alb\_high\_rejected\_connections\_count) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm         | ~> 3.0  |

## Resources

| Name                                                                                                                                                            | Type     |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_sns_topic.ecs_updates](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/sns_topic)                                              | resource |
| [aws_sns_topic.alb_updates](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/sns_topic)                                              | resource |

## Inputs

| Name                                                                                                           | Description                                               | Type            | Default                                                                                                                                                                                                                                                | Required |
|----------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags)                                                                 | Tags to be applied to the resource                        | `map(any)`      | `{}`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_services"></a> [services](#input\_services)                                                     | List of ECS service names                                 | `list(string)`  | `[]`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_alb_id"></a> [alb\_id](#input\_alb\_id)                                                         | ID of the ALB                                             | `string`        | `[]`                                                                                                                                                                                                                                                   |   yes    |
| <a name="input_thresholds"></a> [thresholds](#input\_thresholds)                                               | Alerting thresholds for alerts                            | `map(any)`      | <pre>{<br>  "cpu_utilization_threshold": 95<br>  "memory_threshold": 95<br>  "httpcode_5xx_count_threshold": 30<br>  "httpcode_target_5xx_count_threshold": 30<br>  "latency_threshold": 100<br>  "rejected_connection_count_threshold": 30<br>}</pre> |    no    |

## Outputs

| Name                                                                                         | Description |
|----------------------------------------------------------------------------------------------|-------------|
| <a name="output_monitoring_outputs"></a> [monitoring\_outputs](#output\_monitoring\_outputs) | n/a         |
<!-- END_TF_DOCS -->