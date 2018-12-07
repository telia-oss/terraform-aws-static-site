provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = "${data.aws_vpc.main.id}"
}

# REST OF THE EXAMPLE
module "static-example" {
  source      = "../../"
  name_prefix = "static-example"
  domain_name = "example.com"
  zone_id     = "<zone_id>"
}
