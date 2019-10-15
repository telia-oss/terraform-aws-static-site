provider "aws" {
  region = "eu-west-1"
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
}

