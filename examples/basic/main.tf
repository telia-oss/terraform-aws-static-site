terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = var.region
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
  hosted_zone_name = "<route53-zone-name>"
  site_name        = "www.example.com.<route53-zone-name>"

  tags = {
    environment = "dev"
    terraform   = "True"
  }
}
