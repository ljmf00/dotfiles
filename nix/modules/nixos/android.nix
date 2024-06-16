{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs;
    [
      ccache
      git
      gitRepo
      gnupg
      python2
      curl
      procps
      openssl
      gnumake
      nettools
      android-tools
      jdk
      schedtool
      util-linux
      m4
      gperf
      perl
      libxml2
      zip
      unzip
      bison
      flex
      lzop
      python3
      zlib
      ncurses5
    ];

  environment.sessionVariables = {
    ALLOW_NINJA_ENV = "true";
    USE_CCACHE = "1";
    ANDROID_JAVA_HOME = "${pkgs.jdk.home}sdkmanager install avd";
  };
}
