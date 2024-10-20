variable "API_CLOUDFLARE_TOKEN_TF" {
  description = "The Cloudflare API token. This can also be specified with the CLOUDFLARE_TOKEN shell environment variable."
  type        = string
  sensitive   = true
}
