{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "audio" config.sanix.hardware) {
    xdg.sounds.enable = true;

    # disable pulseaudio
    hardware.pulseaudio.enable = false;
    environment.systemPackages = with pkgs; [
      pulseaudioFull
    ];

    # enable pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    services.pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
    ];

    services.pipewire.extraConfig.pipewire."91-null-sinks" = {
      context.objects = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            factory.name     = "support.node.driver";
            node.name        = "Dummy-Driver";
            priority.driver  = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name     = "support.null-audio-sink";
            node.name        = "Microphone-Proxy";
            node.description = "Microphone";
            media.class      = "Audio/Source/Virtual";
            audio.position   = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name     = "support.null-audio-sink";
            node.name        = "Main-Output-Proxy";
            node.description = "Main Output";
            media.class      = "Audio/Sink";
            audio.position   = "FL,FR";
          };
        }
      ];
    };

    services.pipewire.extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };

    services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "32/48000";
            pulse.default.req = "32/48000";
            pulse.max.req = "32/48000";
            pulse.min.quantum = "32/48000";
            pulse.max.quantum = "32/48000";
          };
        }
      ];
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };

    # enable rtkit
    security.rtkit.enable = true;

    # add kernel modules and parameters
    boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
    boot.kernelParams = [ "snd_usb_audio.implicit_fb=1" ];

    # add pam login limits for audio group
    security.pam.loginLimits = [
        { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
        { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
        { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
        { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
    ];

    # add deviecs to audio udev group
    services.udev = {
        extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        '';
    };
  };
}
