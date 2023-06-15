module "dns" {
    source = "./terraform/dns"
    cloudflare_email = "${var.cloudflare_email}"
    cloudflare_token = "${var.cloudflare_token}"
    cloudflare_zone_id = "${var.cloudflare_zone_id}"
}
