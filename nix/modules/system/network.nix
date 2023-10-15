{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  # Host metadata
  networking.hostName = mkGenericDefault "generic";
  networking.hostId = mkGenericDefault "8425e349";

  networking.hosts = {
    "10.10.10.1" = [ "trex.local" ];
  };

  # Network proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # enable network manager
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Wireless settings (managed by network-manager)
  networking.wireless.iwd.enable = true;
  networking.wireless.userControlled.enable = true;
  systemd.services.wpa_supplicant.wantedBy = mkGenericDefault [];

  # Utility
  services.openssh.enable = true;
  networking.iproute2.enable = true;
  environment.systemPackages = with pkgs;
    [
      tcpdump
      socat
    ];

  # Firewall settings
  networking.nftables.enable = false;
  networking.firewall = {
    enable = false;

    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ ];
    allowPing = false;
  };

  # Hardening settings

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = mkDefault "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = mkDefault "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = mkDefault false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = mkDefault false;
}
