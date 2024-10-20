# =============================================================================
# MX RECORDS
# =============================================================================

#resource "cloudflare_record" "lsferreira_net_mx1" {
#  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
#  name = "lsferreira.net"
#  value = "route1.mx.cloudflare.net"
#  priority = 59
#  type = "MX"
#}
#
#resource "cloudflare_record" "lsferreira_net_mx2" {
#  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
#  name = "lsferreira.net"
#  value = "route2.mx.cloudflare.net"
#  priority = 100
#  type = "MX"
#}
#
#resource "cloudflare_record" "lsferreira_net_mx3" {
#  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
#  name = "lsferreira.net"
#  value = "route3.mx.cloudflare.net"
#  priority = 92
#  type = "MX"
#}

# =============================================================================
# SPF / DMARC
# =============================================================================

resource "cloudflare_record" "lsferreira_net_spf" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "lsferreira.net"
  value = "v=spf1 include:_spf.mx.cloudflare.net +ip4:193.108.130.14 +include:spf.mxyeet.net +include:_spf.lsferreira.net ~all"
  type = "TXT"
  comment = "terraform"
}

resource "cloudflare_record" "lsferreira_net_dmarc" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "_dmarc"
  value = "v=DMARC1;p=quarantine;sp=quarantine;pct=100;rua=mailto:cdbf63edcf5a46f6a003272a9f314ef1@dmarc-reports.cloudflare.net;ruf=mailto:cdbf63edcf5a46f6a003272a9f314ef1@dmarc-reports.cloudflare.net;ri=86400;aspf=s;adkim=s;fo=0:1:d:s;"
  type = "TXT"
  comment = "terraform"
}

# =============================================================================
# DKIM
# =============================================================================

resource "cloudflare_record" "lsferreira_net_dkim1" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "protonmail._domainkey"
  value = "protonmail.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "lsferreira_net_dkim2" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "protonmail2._domainkey"
  value = "protonmail2.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "lsferreira_net_dkim3" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "protonmail3._domainkey"
  value = "protonmail3.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

# =============================================================================
# MANUAL CONFIGURATION
# =============================================================================

resource "cloudflare_record" "smtp" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "smtp"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "pop3" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "pop3"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

# Alias to pop3
resource "cloudflare_record" "pop" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "pop"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "imap" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "imap"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}


# =============================================================================
# AUTO CONFIGURATION
# =============================================================================

resource "cloudflare_record" "autoconfig" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "autoconfig"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "autodiscover" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "autodiscover"
  value = "lu-shared04.cpanelplatform.com"
  proxied = false
  type = "CNAME"
  comment = "terraform"
}

resource "cloudflare_record" "srv_autoconfig" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_autoconfig._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_autoconfig._tcp._autoconfig"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 443
    target   = "autoconfig.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_autodiscover" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_autodiscover._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_autodiscover._tcp._autodiscover"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 443
    target   = "autodiscover.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_smtp" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_submission._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_submission._tcp._submission"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 465
    target   = "smtp.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_pop3" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_pop3._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_pop3._tcp._pop3"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 110
    target   = "pop3.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_pop3s" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_pop3s._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_pop3s._tcp._pop3s"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 995
    target   = "pop3.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_imap" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_imap._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_imap._tcp._imap"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 143
    target   = "imap.lsferreira.net"
  }

  comment = "terraform"
}

resource "cloudflare_record" "srv_imaps" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name    = "_imaps._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_imaps._tcp._imaps"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 993
    target   = "imap.lsferreira.net"
  }

  comment = "terraform"
}


# =============================================================================
# WEBMAIL
# =============================================================================

resource "cloudflare_record" "webmail" {
  zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id
  name = "webmail"
  value = "lu-shared04.cpanelplatform.com"
  type = "CNAME"

  comment = "terraform"
}
