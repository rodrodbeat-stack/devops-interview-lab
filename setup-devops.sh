#!/usr/bin/env bash
set -e

echo "=== PREPARANDO LABORATORIO DEVOPS ==="

sudo apt-get update
sudo apt-get install -y curl wget unzip git jq

# Terraform
if ! command -v terraform >/dev/null 2>&1; then
  TF_VERSION="1.13.5"
  ARCH="$(uname -m)"

  case "$ARCH" in
    x86_64) TF_ARCH="amd64" ;;
    aarch64|arm64) TF_ARCH="arm64" ;;
    *) echo "Arquitectura no compatible"; exit 1 ;;
  esac

  wget -q \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${TF_ARCH}.zip" \
    -O /tmp/terraform.zip

  unzip -o /tmp/terraform.zip -d /tmp
  sudo install -m 0755 /tmp/terraform /usr/local/bin/terraform
fi

# AWS CLI
if ! command -v aws >/dev/null 2>&1; then
  ARCH="$(uname -m)"

  case "$ARCH" in
    x86_64) AWS_ARCH="x86_64" ;;
    aarch64|arm64) AWS_ARCH="aarch64" ;;
    *) echo "Arquitectura no compatible"; exit 1 ;;
  esac

  curl -fsSL \
    "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
    -o /tmp/awscliv2.zip

  unzip -oq /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
fi

mkdir -p terraform

cat > terraform/main.tf <<'TF'
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
TF

cat > terraform/.gitignore <<'GIT'
.terraform/
*.tfstate
*.tfstate.*
crash.log
GIT

terraform -chdir=terraform init -input=false
terraform -chdir=terraform fmt
terraform -chdir=terraform validate
terraform -chdir=terraform plan -input=false

echo "=== LABORATORIO PREPARADO ==="
terraform version
aws --version

