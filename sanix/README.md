# sanix
Sane configurations flake for NixOS

## Example

```nix
sanix.hardware = [
  "cpu-x86_64-amd-zen3" "gpu-amd" "audio" "usb" "wifi" "ethernet" "bluetooth"
];

sanix.features = [
  "unfree" "hardening"
  "documentation" "fonts"
  "graphical-gnome"
];
```

## Hardware configurations

- `cpu-x86_64`: Generic x86_64 processor
- `cpu-x86_64-kvm`: Generic x86_64 processor with KVM support (hardware virtualization)
- `cpu-x86_64-amd`: Generic AMD x86_64 processor
- `cpu-x86_64-amd-pstate`: Generic AMD x86_64 processor with amd-pstate driver
- `cpu-x86_64-amd-zen3`: x86_64 AMD processor with Zen3 Architecture
- `gpu`: Generic GPU (Accelerated graphics)
- `gpu-amd`: System has an AMD graphics card
- `audio`: Indicates the hardware has audio capabilities
- `usb`: Hardware accepts USB devices
- `wifi`: Hardware contains a WiFi network card
- `bluetooth`: Hardware contains a Bluetooth network card
- `ethernet`: Hardware contains ethernet port
- `virtualization-guest`: Hardware is used with virtualization (guest)
- `virtualization-host`: Hardware is used for virtualization (host)

## System features

- `boot-ext4`: Your boot drive is formatted with ext4
- `boot-luks`: Your boot drive is encrypted with LUKS
- `boot-btrfs`: Your boot drive is formatted with BTRFS
- `boot-swap`: Your boot drive has a swap partition
- `btrfs`: Your system has a BTRFS drive
- `ext4`: Your system has a ext4 drive
- `swraid`: Your system has software RAID
- `zfs`: Your system has ZFS
- `boot-efi-esp`: Your system is formatted with EFI mode (ESP partition)
- `boot-efi-nonesp`: Your system is formatted with EFI mode (non-ESP partition)
- `boot-mbr`: Your system is formatted in BIOS/MBR mode
- `unfree`: Your system allows unfree packages
- `firmware-redist`: Your system installs redistributable firmware
- `firmware-all`: Your system installs all firmware
- `firmware-update`: Your system has firmware update checks
- `documentation`: Installs documentation packages
- `fonts`: Installs common fonts
- `hardening`: Includes hardening restrictive environment
- `emulate-riscv`: Emulates RISC-V via binfmt
- `emulate-wasm`: Emulates WASM via binfmt
- `emulate-arm`: Emulates ARM via binfmt
- `graphical`: Your system support graphical environment
- `graphical-gnome`: Install gnome graphical environment
- `graphical-dm-gdm`: Install GDM display manager
- `syncthing`: Install and configure syncthing
- `firefox`: Install and configure firefox
- `utility-rescue`: Install rescue utility
- `utility-dev`: Install development utility
- `utility-local-proxy`: Install local proxy for installed services (`<name-of-the-service>.local`)