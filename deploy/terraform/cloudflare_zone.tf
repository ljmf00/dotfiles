data "cloudflare_zones" "lsferreira_net" {
  filter {
    name = "lsferreira.net"
  }
}

data "cloudflare_zones" "luisf_eu_org" {
  filter {
    name = "luisf.eu.org"
  }
}
