locals {
  identifier = "${var.identifier}-${terraform.workspace}"
  tags       = merge({ Terraform = "true" }, var.tags)
}