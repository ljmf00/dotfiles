resource "cloudflare_record" "ft_s_lu_04_cname_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "ft-s-lu-04._.lsferreira.net"
  value = "lu-shared04.cpanelplatform.com"
  type = "CNAME"
  proxied = false

  tags = [ "terraform" ]
}

resource "cloudflare_record" "ft_s_lu_04_ptr_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "14.130.108.193.in-addr.arpa.lsferreira.net"
  value = "lu-shared04.cpanelplatform.com"
  type = "PTR"
  proxied = false

  tags = [ "terraform" ]
}

resource "cloudflare_record" "nc_anx04_1_a_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "nc-anx04-1._.lsferreira.net"
  value = "152.53.18.215"
  type = "A"
  proxied = false

  tags = [ "terraform" ]
}

resource "cloudflare_record" "dh_p_de_frkt_02_a_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "dh-p-de_frkt-02._.lsferreira.net"
  value = "212.115.124.79"
  type = "A"
  proxied = false

  tags = [ "terraform" ]
}

resource "cloudflare_record" "dh_p_de_frkt_02_aaaa_lsferreira" {
  zone_id = var.cloudflare_zone_id
  name = "dh-p-de_frkt-02._.lsferreira.net"
  value = "2a05:bec0:34:6f46:cafe:ffff:ffff:1"
  type = "AAAA"
  proxied = false

  tags = [ "terraform" ]
}
