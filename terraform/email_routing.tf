resource "cloudflare_email_routing_settings" "lsferreira_net" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  enabled = "true"
}
