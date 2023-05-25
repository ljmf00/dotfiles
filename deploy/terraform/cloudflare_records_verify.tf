resource "cloudflare_record" "txt_protonmail_verify" {
  zone_id = var.cloudflare_zone_id
  name = "lsferreira.net"
  value = "protonmail-verification=70cccbdc7c9d67117259cae0540686df67aa782f"
  type = "TXT"
}

resource "cloudflare_record" "txt_google_verify" {
  zone_id = var.cloudflare_zone_id
  name = "lsferreira.net"
  value = "google-site-verification=GDP0s9B0oHyrvGkd95NkXaNLRJvzC49CYLSzCHJyEaw"
  type = "TXT"
}

resource "cloudflare_record" "txt_keybase_verify" {
  zone_id = var.cloudflare_zone_id
  name = "lsferreira.net"
  value = "keybase-site-verification=V_PHY7UrKUjJ0V0NpUfi-uJBTYS-UBZCtScmP65VLyI"
  type = "TXT"
}

resource "cloudflare_record" "txt_brave_verify" {
  zone_id = var.cloudflare_zone_id
  name = "lsferreira.net"
  value = "brave-ledger-verification=cd8be7b9dafc3349d08c6adff904af7629173c8b42ccff04926f3317c0da823a"
  type = "TXT"
}
