resource "cloudflare_argo" "lsferreira_net" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  tiered_caching = "on"
}

resource "cloudflare_argo" "luisf_eu_org" {
  zone_id = data.cloudflare_zones.luisf_eu_org.zones[0].id
  tiered_caching = "on"
}
