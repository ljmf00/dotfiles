resource "cloudflare_record" "txt_protonmail_verify" {
  zone_id = var.cloudflare_zone_id
  name = "lsferreira.net"
  value = "protonmail-verification=70cccbdc7c9d67117259cae0540686df67aa782f"
  type = "TXT"
}
