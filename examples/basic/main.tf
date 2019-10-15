terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = ">= 2.27"
  region  = var.region
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}

module "static-example" {
  source           = "../../"
  name_prefix      = "static-example"
  hosted_zone_name = "example.com"
  site_name        = "www.example.com"

  tags = {
    environment = "dev"
    terraform   = "True"
  }
}
