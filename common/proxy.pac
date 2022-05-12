function FindProxyForURL(url, host) {
  // First: prevent resolving through normal DNS to avoid DNS leaks.

  // TOR address
  if (dnsDomainIs(host, ".onion"))
    return "SOCKS5 localhost:9050";
  // I2P address
  if (dnsDomainIs(host, ".i2p"))
    return "PROXY localhost:4444; SOCKS localhost:4447";

  // Don't trust TOR/I2P for unencrypted and non-TOR/non-I2P connections
  if (shExpMatch(url, "http://*") || shExpMatch(url, "ftp://*"))
    return null;

  // Avoid using proxy config with servers requiring a strict secure connection
  // or highly controlled networks, use isolated secure sandbox/virtual
  // environment instead. This will prevent TOR connections for those hosts!
  if (dnsDomainIs(host, ".gov"))
    return null;

  // TODO: Use local proxy
  if (dnsDomainIs(host, "sourcegraph.com"))
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
