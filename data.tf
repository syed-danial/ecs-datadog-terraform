data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_default_tags" "default_tags" {}


data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
