{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "ata" config.sanix.hardware) {
    boot.initrd.availableKernelModules = [
        "ahci"

        "ata_piix"

        "sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
        "sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
        "sata_uli" "sata_via" "sata_vsc"

        "pata_ali" "pata_amd" "pata_artop" "pata_atiixp" "pata_efar"
        "pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
        "pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
        "pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
        "pata_pcmcia" "pata_pdc2027x" "pata_qdi" "pata_rz1000"
        "pata_serverworks" "pata_sil680" "pata_sis"
        "pata_sl82c105" "pata_triflex" "pata_via"
        "pata_winbond"
    ];
  };
}