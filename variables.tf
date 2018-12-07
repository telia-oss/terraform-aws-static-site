# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "domain_name" {
  description = "The domain (or subdomain) for this site."
}

variable "bucket_versioning" {
  default = "true"
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain the dns record for this site."
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = "map"
  default     = {}
}

variable "host_name" {
  description = "The host name for this site"
  default     = "www"
}
