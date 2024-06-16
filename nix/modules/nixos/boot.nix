{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_8.override {
    argsOverride = rec {
      src = pkgs.fetchFromGitHub {
          owner = "acjl-ops";
          repo = "linux";
          rev = "v6.8.6-acjl1";
          sha256 = "sha256-OtQ5h/d4+qrYmoMnB8fnsWaHFZEDdv0i9s/YhUQBEKU=";
      };

      version = "6.8.6";
      modDirVersion = "6.8.6-acjl1";

      structuredExtraConfig =
        with lib;
        with lib.kernel;
        with (lib.kernel.whenHelpers version);
      {
          # Report BUG() conditions and kill the offending process.
          BUG = yes;

          # Mark LSM hooks read-only after init.  SECURITY_WRITABLE_HOOKS n
          # conflicts with SECURITY_SELINUX_DISABLE y; disabling the latter
          # implicitly marks LSM hooks read-only after init.
          #
          # SELinux can only be disabled at boot via selinux=0
          #
          # We set SECURITY_WRITABLE_HOOKS n primarily for documentation purposes; the
          # config builder fails to detect that it has indeed been unset.
          SECURITY_SELINUX_DISABLE = whenOlder "6.4" no; # On 6.4: error: unused option: SECURITY_SELINUX_DISABLE
          SECURITY_WRITABLE_HOOKS  = option no;

          STRICT_KERNEL_RWX = yes;

          # Perform additional validation of commonly targeted structures.
          DEBUG_CREDENTIALS     = whenOlder "6.6" yes;
          DEBUG_NOTIFIERS       = yes;
          DEBUG_PI_LIST         = whenOlder "5.2" yes; # doesn't BUG()
          DEBUG_PLIST           = whenAtLeast "5.2" yes;
          DEBUG_SG              = yes;
          DEBUG_VIRTUAL         = yes;
          SCHED_STACK_END_CHECK = yes;

          REFCOUNT_FULL = whenOlder "5.4.208" yes;

          # tell EFI to wipe memory during reset
          # https://lwn.net/Articles/730006/
          RESET_ATTACK_MITIGATION = yes;

          # restricts loading of line disciplines via TIOCSETD ioctl to CAP_SYS_MODULE
          CONFIG_LDISC_AUTOLOAD = option no;

          # Randomize page allocator when page_alloc.shuffle=1
          SHUFFLE_PAGE_ALLOCATOR = whenAtLeast "5.2" yes;

          # Wipe higher-level memory allocations on free() with page_poison=1
          PAGE_POISONING           = yes;
          PAGE_POISONING_NO_SANITY = whenOlder "5.11" yes;
          PAGE_POISONING_ZERO      = whenOlder "5.11" yes;

          # Enable init_on_alloc and init_on_free by default
          INIT_ON_ALLOC_DEFAULT_ON = whenAtLeast "5.3" yes;
          INIT_ON_FREE_DEFAULT_ON  = whenAtLeast "5.3" yes;

          # Wipe all caller-used registers on exit from a function
          ZERO_CALL_USED_REGS = whenAtLeast "5.15" yes;

          # Enable the SafeSetId LSM
          SECURITY_SAFESETID = whenAtLeast "5.1" yes;

          # Reboot devices immediately if kernel experiences an Oops.
          PANIC_TIMEOUT = freeform "-1";

          GCC_PLUGINS = yes; # Enable gcc plugin options
          # Gather additional entropy at boot time for systems that may not have appropriate entropy sources.
          GCC_PLUGIN_LATENT_ENTROPY = yes;

          GCC_PLUGIN_STRUCTLEAK = option yes; # A port of the PaX structleak plugin
          GCC_PLUGIN_STRUCTLEAK_BYREF_ALL = option yes; # Also cover structs passed by address
          GCC_PLUGIN_STACKLEAK = whenAtLeast "4.20" yes; # A port of the PaX stackleak plugin
          GCC_PLUGIN_RANDSTRUCT = whenOlder "5.19" yes; # A port of the PaX randstruct plugin
          GCC_PLUGIN_RANDSTRUCT_PERFORMANCE = whenOlder "5.19" yes;

          # Runtime undefined behaviour checks
          # https://www.kernel.org/doc/html/latest/dev-tools/ubsan.html
          # https://developers.redhat.com/blog/2014/10/16/gcc-undefined-behavior-sanitizer-ubsan
          UBSAN      = yes;
          UBSAN_TRAP = whenAtLeast "5.7" yes;
          UBSAN_BOUNDS = whenAtLeast "5.7" yes;
          UBSAN_SANITIZE_ALL = yes;
          UBSAN_LOCAL_BOUNDS = option yes; # clang only
          CFI_CLANG = option yes; # clang only Control Flow Integrity since 6.1

          # Same as GCC_PLUGIN_RANDSTRUCT*, but has been renamed to `RANDSTRUCT*` in 5.19.
          RANDSTRUCT = whenAtLeast "5.19" yes;
          RANDSTRUCT_PERFORMANCE = whenAtLeast "5.19" yes;

          # Disable various dangerous settings
          ACPI_CUSTOM_METHOD = no; # Allows writing directly to physical memory
          PROC_KCORE         = no; # Exposes kernel text image layout
          INET_DIAG          = no; # Has been used for heap based attacks in the past

          # INET_DIAG=n causes the following options to not exist anymore, but since they are defined in common-config.nix,
          # make them optional
          INET_DIAG_DESTROY = option no;
          INET_RAW_DIAG     = option no;
          INET_TCP_DIAG     = option no;
          INET_UDP_DIAG     = option no;
          INET_MPTCP_DIAG   = option no;

          # Use -fstack-protector-strong (gcc 4.9+) for best stack canary coverage.
          CC_STACKPROTECTOR_REGULAR = lib.mkForce (whenOlder "4.18" no);
          CC_STACKPROTECTOR_STRONG  = whenOlder "4.18" yes;

          # Detect out-of-bound reads/writes and use-after-free
          KFENCE = whenAtLeast "5.12" yes;

          # CONFIG_DEVMEM=n causes these to not exist anymore.
          STRICT_DEVMEM    = option no;
          IO_STRICT_DEVMEM = option no;

          # stricter IOMMU TLB invalidation
          IOMMU_DEFAULT_DMA_STRICT = option yes;
          IOMMU_DEFAULT_DMA_LAZY = option no;

          # not needed for less than a decade old glibc versions
          LEGACY_VSYSCALL_NONE = yes;

          # Straight-Line-Speculation
          # https://lwn.net/Articles/877845/
          SLS = option yes;

          # Linux RT
          # PREEMPT_RT = yes;
          # Fix error: unused option: PREEMPT_RT.
          # EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt)
          # Fix error: option not set correctly: PREEMPT_VOLUNTARY (wanted 'y', got 'n').
          # PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
          # Fix error: unused option: RT_GROUP_SCHED.
          # RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
      };
    };
  });

    environment.systemPackages = with pkgs;
    [
      # detect Microsoft (DOS) boot sectors / MBRs
      ms-sys
    ];
}
