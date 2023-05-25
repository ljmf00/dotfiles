data "cloudflare_zones" "lsferreira_net" {
  filter {
    name = "lsferreira.net"
  }
}

resource "cloudflare_zone_settings_override" "lsferreira_net_settings" {
    zone_id = data.cloudflare_zones.lsferreira_net.zones[0].id

    settings {
        # SSL/TLS
        ssl = "strict"
        tls_1_3 = "zrt"
        min_tls_version = "1.3"

        # HTTP(S)
        always_use_https = "on"
        automatic_https_rewrites = "on"
        opportunistic_encryption = "on"
        /* http2 = "on" # read-only */
        http3 = "on"

        # Network
        zero_rtt = "on"
        websockets = "on"

        # IPv4/IPv6
        pseudo_ipv4 = "off"
        ipv6 = "on"

        # Tor
        opportunistic_onion = "on"

        # Caching
        development_mode = "off"
        cache_level = "basic"
        browser_cache_ttl = 14400
        rocket_loader = "off"
        minify {
            css = "on"
            js = "on"
            html = "on"
        }

        # Compression
        brotli = "on"

        # Security
        security_level = "high"
        challenge_ttl = 86400
        security_header {
            enabled = true
        }
    }
}
