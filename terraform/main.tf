terraform {
  required_version = ">= 1.5.0"
}

variable "environment" {
  type    = string
  default = "dev"
}

locals {
  project = "devops-interview-lab"

  tags = {
    Project     = local.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "project" {
  value = local.project
}

output "environment" {
  value = var.environment
}

output "tags" {
  value = local.tags
}
