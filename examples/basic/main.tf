terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = var.region
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
