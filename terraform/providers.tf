terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.8.0"
    }
  }
}

provider "cloudflare" {
  api_token = "${var.API_CLOUDFLARE_TOKEN_TF}"
}
