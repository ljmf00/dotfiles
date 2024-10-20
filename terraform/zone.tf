data "cloudflare_zones" "lsferreira_net" {
  filter {
    name = "lsferreira.net"
  }
}
