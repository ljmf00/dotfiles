resource "cloudflare_record" "s_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "s.lsferreira.net"
  value = "l4-shared04.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "cloud_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "cloud.lsferreira.net"
  value = "l4-shared04.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "feed_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "feed.lsferreira.net"
  value = "l4-shared04.lsferreira.net"
  type = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "a_lsferreira_lu_shared04" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "lu-shared04.lsferreira.net"
  value = "193.108.130.14"
  type = "A"
  allow_overwrite = true
}
