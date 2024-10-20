resource "cloudflare_record" "s_lsferreira" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "s.lsferreira.net"
  value = "nc-anx04-1._.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "rss_lsferreira" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "rss.lsferreira.net"
  value = "ft-s-lu-04._.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "social_lsferreira" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "social.lsferreira.net"
  value = "ft-s-lu-04._.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "feed_lsferreira" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "feed.lsferreira.net"
  value = "ft-s-lu-04._.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}
