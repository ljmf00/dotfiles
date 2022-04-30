variable "cloudflare_email" {
  description = "The email associated with the account. This can also be specified with the CLOUDFLARE_EMAIL shell environment variable."
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "The Cloudflare API token. This can also be specified with the CLOUDFLARE_TOKEN shell environment variable."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "The DNS zone ID to add the record to."
  type        = string
  sensitive   = true
}
