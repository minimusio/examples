# Simple test Terraform configuration
# Create this file in a new repository to test Atlantis

terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Simple local file resource for testing
resource "local_file" "test" {
  content  = "Hello from MINIMUS!!!! Atlantis!!! Generated at: ${timestamp()}"
  filename = "${path.module}/test-output.txt"
}

# Output the file content
output "file_content" {
  value = local_file.test.content
}

# Variables for testing
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

# Another resource to make changes interesting
resource "local_file" "environment_info" {
  content  = "Environment: ${var.environment}\nDeployed by: Atlantis\nTimestamp: ${timestamp()}"
  filename = "${path.module}/environment-${var.environment}.txt"
}
