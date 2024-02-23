{ config, pkgs, lib, inputs, ...}:
let 
  listOfDMs = (builtins.filter (e: (builtins.match "^graphical-dm-.*" e) != null) config.sanix.features);
  assertUniqDM = (builtins.length listOfDMs) <= 1 
    || (builtins.throw "Only one display manager should be defined");
in with lib;
{}