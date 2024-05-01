terraform {
  required_version = ">= 1.5.4"
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.34.0"
    }
  }
}