{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # protect the kernel image
  security.protectKernelImage = true;
}
