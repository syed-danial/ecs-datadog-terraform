variable "semantic_version" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "identifier" {
  description = "Name prefix for the resources"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "dd_api_key" {
  type = string
  description = "Datadog API Key"
}
variable "dd_app_key" {
  type = string
  description = "Datadog API Key"
}
variable "monitor_settings" {
  default = {}
}