variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "services" {
  description = "List of ECS service names"
  type        = list(string)
  default     = []
}

variable "alb_ids" {
  description = "List of ALB IDs"
  type        = list(string)
  default     = []
}

variable "thresholds" {
  description = "Alerting thresholds for alerts"
  type        = map(any)
  default = {
    cpu_utilization_threshold           = 95
    memory_threshold                    = 95
    httpcode_5xx_count_threshold        = 30
    httpcode_target_5xx_count_threshold = 30
    latency_threshold                   = 100
    rejected_connection_count_threshold = 30
  }
}