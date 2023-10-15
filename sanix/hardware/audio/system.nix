{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "audio" config.sanix.hardware) {
    # Enable sound.
    sound.enable = true;
    sound.extraConfig = ''
        cards.USB-Audio.pcm.iec958_device."Behringer UV1" 999
    '';
    xdg.sounds.enable = true;

    # enable pipewire
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;

        pulse.enable = true;
        wireplumber.enable = true;
        # jack.enable = true;
    };

    # disable pulseaudio
    hardware.pulseaudio.enable = false;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    nixpkgs.config.pulseaudio = true;

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