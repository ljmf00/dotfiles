# =============================================================================
# MX RECORDS
# =============================================================================

resource "cloudflare_record" "mx1" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "lsferreira.net"
  value = "mx1.improvmx.com"
  priority = 10
  type = "MX"
}

resource "cloudflare_record" "mx2" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "lsferreira.net"
  value = "mx2.improvmx.com"
  priority = 20
  type = "MX"
}


# =============================================================================
# SPF / DMARC
# =============================================================================

resource "cloudflare_record" "spf" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "lsferreira.net"
  value = "v=spf1 include:mx.ovh.com include:spf.improvmx.com ~all"
  type = "TXT"
}

resource "cloudflare_record" "dmarc" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "_dmarc"
  value = "v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@lsferreira.net; ruf=mailto:dmarc@lsferreira.net; fo=1:s:d; adkim=r; aspf=r"
  type = "TXT"
}


# =============================================================================
# MANUAL CONFIGURATION
# =============================================================================

resource "cloudflare_record" "smtp" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "smtp"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "pop3" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "pop3"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}

# Alias to pop3
resource "cloudflare_record" "pop" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "pop"
  value = "pop3.lsferreira.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "imap" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "imap"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}


# =============================================================================
# AUTO CONFIGURATION
# =============================================================================

resource "cloudflare_record" "autoconfig" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "autoconfig"
  value = "mailconfig.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "autodiscover" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "autodiscover"
  value = "mailconfig.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "srv_autodiscover" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_autodiscover._tcp"
  type    = "SRV"

  data {
    service  = "_autodiscover"
    proto    = "_tcp"
    name     = "_autodiscover._tcp"
    priority = 0
    weight   = 0
    port     = 443
    target   = "mailconfig.ovh.net"
  }
}

resource "cloudflare_record" "srv_smtp" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_submission._tcp"
  type    = "SRV"

  data {
    service  = "_submission"
    proto    = "_tcp"
    name     = "_submission._tcp"
    priority = 0
    weight   = 0
    port     = 465
    target   = "smtp.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_pop3" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_pop3._tcp"
  type    = "SRV"

  data {
    service  = "_pop3"
    proto    = "_tcp"
    name     = "_pop3._tcp"
    priority = 0
    weight   = 0
    port     = 110
    target   = "pop3.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_pop3s" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_pop3s._tcp"
  type    = "SRV"

  data {
    service  = "_pop3s"
    proto    = "_tcp"
    name     = "_pop3s._tcp"
    priority = 0
    weight   = 0
    port     = 995
    target   = "pop3.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_imap" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_imap._tcp"
  type    = "SRV"

  data {
    service  = "_imap"
    proto    = "_tcp"
    name     = "_imap._tcp"
    priority = 0
    weight   = 0
    port     = 143
    target   = "imap.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_imaps" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "_imaps._tcp"
  type    = "SRV"

  data {
    service  = "_imaps"
    proto    = "_tcp"
    name     = "_imaps._tcp"
    priority = 0
    weight   = 0
    port     = 993
    target   = "imap.lsferreira.net"
  }
}


# =============================================================================
# WEBMAIL
# =============================================================================

resource "cloudflare_record" "webmail" {
  zone_id = "${var.cloudflare_zone_id}"
  name = "webmail"
  value = "ssl0.ovh.net"
  type = "CNAME"
}
