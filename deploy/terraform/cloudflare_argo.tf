resource "cloudflare_argo" "lsferreira_net" {
  zone_id = "${var.cloudflare_zone_id}"
  tiered_caching = "on"
}
