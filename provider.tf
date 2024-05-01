terraform {
  required_version = ">= 1.5.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.34.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Version        = var.semantic_version
      Project        = "Terraform AWS ECS DD Intergration"
      Environment    = terraform.workspace
    }
  }
}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
}
