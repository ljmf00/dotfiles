{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  system.stateVersion = mkDefault lib.trivial.release;
}
