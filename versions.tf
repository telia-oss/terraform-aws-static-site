
terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.49" # Version 3.0 introduces breaking change
    }
  }
}
