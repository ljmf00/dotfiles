resource "cloudflare_record" "a_s_lsferreira_webapp" {
  zone_id = var.cloudflare_zone_id
  name = "s.lsferreira.net"
  value = "193.108.130.14"
  type = "A"
}
