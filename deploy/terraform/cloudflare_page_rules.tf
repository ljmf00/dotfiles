resource "cloudflare_page_rule" "page_rule_1" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  target = "http://*.lsferreira.net/*"
  priority = 1

  actions {
    always_use_https = true
  }
}

resource "cloudflare_page_rule" "page_rule_2" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  target = "http://lsferreira.net/*"
  priority = 2

  actions {
    always_use_https = true
  }
}

resource "cloudflare_page_rule" "page_rule_3" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  target = "lsferreira.net/*"
  priority = 3

  actions {
    automatic_https_rewrites = "on"
  }
}
