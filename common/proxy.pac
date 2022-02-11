function FindProxyForURL(url, host) {
  // First: prevent resolving through normal DNS to avoid DNS leaks.

  // TOR address
  if (dnsDomainIs(host, ".onion"))
    return "SOCKS5 localhost:9050";
  // I2P address
  if (dnsDomainIs(host, ".i2p"))
    return "PROXY localhost:4444; SOCKS localhost:4447";

  // Portugal internet blocking workaround
  if (
    dnsResolve(host) == "195.23.113.202" ||
    dnsResolve(host) == "195.23.113.206" ||
    dnsResolve(host) == "213.13.145.120" ||
    dnsResolve(host) == "212.18.182.164" ||
    dnsResolve(host) == "212.18.182.197" ||
    dnsResolve(host) == "213.228.128.216" ||
    dnsResolve(host) == "213.228.128.215")
    return "PROXY proxy1.ahoy.pro:3128; " +
      "PROXY proxy2.ahoy.pro:3128; " +
      "PROXY proxy3.ahoy.pro:3128; " +
      "PROXY proxy4.ahoy.pro:3128; " +
      "PROXY proxy5.ahoy.pro:3128";

  // Don't trust TOR/I2P for unencrypted and non-TOR/non-I2P connections
  if (shExpMatch(url, "http://*") || shExpMatch(url, "ftp://*"))
    return "DIRECT";

  // Whitelist some hostnames that are impossible to run under TOR network.
  if (
    dnsDomainIs(host, "rtp.pt") ||
    dnsDomainIs(host, "devdocs.io") ||
    dnsDomainIs(host, "patreon.com") ||
    dnsDomainIs(host, "liberapay.com") ||
    dnsDomainIs(host, "pre-commit.com") ||
    dnsDomainIs(host, "pre-commit.ci") ||
    dnsDomainIs(host, "issues.dlang.org") ||
    dnsDomainIs(host, "nft.storage") ||
    dnsDomainIs(host, "web3.storage") ||
    dnsDomainIs(host, "magic.link") ||
    dnsDomainIs(host, "sourcegraph.com") ||
    dnsDomainIs(host, "youtube.com") ||
    dnsDomainIs(host, "google.com") ||
    dnsDomainIs(host, "google.pt") ||
    dnsDomainIs(host, "stackexchange.com")
    )
    return "DIRECT";

  // Avoid using proxy config with servers requiring a strict secure connection
  // or highly controlled networks, use isolated secure sandbox/virtual
  // environment instead. This will prevent TOR connections for those hosts!
  if (
    dnsDomainIs(host, "creditoagricola.pt") ||
    dnsDomainIs(host, "eurobic.pt") ||
    dnsDomainIs(host, "cgd.pt") ||
    dnsDomainIs(host, "seg-social.pt") ||
    dnsDomainIs(host, "paypal.com") ||
    dnsDomainIs(host, "stripe.com") ||
    dnsDomainIs(host, "gov.pt") ||
    dnsDomainIs(host, ".gov"))
    return "DIRECT";

  // Cloudflare doesn't understand the TOR concept, lets pipe it out of the
  // network.
  if (
    isInNet(host, "173.245.48.0", "255.255.240.0") ||
    isInNet(host, "103.21.244.0", "255.255.248.0") ||
    isInNet(host, "103.22.200.0", "255.255.248.0") ||
    isInNet(host, "103.31.4.0", "255.255.248.0") ||
    isInNet(host, "197.234.240.0", "255.255.248.0") ||
    isInNet(host, "141.101.64.0", "255.255.192.0") ||
    isInNet(host, "108.162.192.0", "255.255.192.0") ||
    isInNet(host, "131.0.72.0", "255.255.248.0") ||
    isInNet(host, "172.64.0.0", "255.248.0.0") ||
    isInNet(host, "104.16.0.0", "255.248.0.0") ||
    isInNet(host, "162.158.0.0", "255.254.0.0") ||
    isInNet(host, "198.41.128.0", "255.255.128.0") ||
    isInNet(host, "190.93.240.0", "255.255.240.0") ||
    isInNet(host, "188.114.96.0", "255.255.240.0"))
    return "DIRECT";

  // Local addresses and probably local hosts or loopback aliases
  if (
    isInNet(host, "169.254.0.0", "255.255.0.0") || /* link-local */
    isInNet(host, "192.168.0.0", "255.255.0.0") || /* local */
    isInNet(host, "172.16.0.0", "255.240.0.0") ||  /* local */
    isInNet(host, "10.0.0.0", "255.0.0.0") || /* local */
    !isResolvable(host) || isPlainHostName(host)) /* unresolvable or plain hosts */
    return "DIRECT";

  return "SOCKS5 localhost:9050";
}
