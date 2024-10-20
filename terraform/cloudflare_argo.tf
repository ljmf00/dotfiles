resource "cloudflare_argo" "lsferreira_net" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  tiered_caching = "on"
}
