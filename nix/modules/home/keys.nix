{ config, pkgs, lib, inputs, ...}:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  services.gnome-keyring = {
    enable = false;
    components = [ "pkcs11" "secrets" ];
  };

  programs.gpg = {
    enable = true;
    settings = {
      no-greeting = true;
      use-agent = true;
      keyserver-options = "timeout=10";
      keyserver = "hkp://keyserver.ubuntu.com";
    };
  };

  services.gpg-agent = {
    enable                = true;
    enableBashIntegration = true;
    enableExtraSocket     = true;
    enableSshSupport      = true;

    pinentryPackage = mkGenericDefault pkgs.pinentry-curses;
  };

  # Prevent clobbering SSH_AUTH_SOCK
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${lib.fileContents "${pkgs.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';
}
