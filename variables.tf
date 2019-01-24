# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone in which to register this site"
}

variable "bucket_versioning" {
  description = "(Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  default     = "true"
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = "map"
  default     = {}
}

variable "site_name" {
  description = "The name of the certificate and address for the site"
}
