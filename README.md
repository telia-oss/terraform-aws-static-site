# Static Site

[![workflow](https://github.com/telia-oss/terraform-aws-static-site/workflows/workflow/badge.svg)](https://github.com/telia-oss/terraform-aws-static-site/actions)

Use this module to create a static website that is hosted in S3 and delivered everywhere from local edge locations using Cloudfront
#### Prerequisites
AWS Account with hosted zone for domain to deploy to

#### Note
This module creates a us-east-1 certificate as this is a requirement for cloudfront.

## Examples

* [Simple Example](examples/default/main.tf)

## Authors

Currently maintained by [these contributors](../../graphs/contributors).

## License

MIT License. See [LICENSE](LICENSE) for full details.


