resource "cloudflare_email_routing_settings" "luisf_eu_org" {
  zone_id = data.cloudflare_zones.luisf_eu_org.zones[0].id
  enabled = "true"
}

resource "cloudflare_email_routing_catch_all" "luisf_eu_org" {
  zone_id = data.cloudflare_zones.luisf_eu_org.zones[0].id
  name    = "catch all"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "forward"
    value = ["catchall@lsferreira.net"]
  }
}
