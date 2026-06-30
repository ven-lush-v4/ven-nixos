#kernel.nix
{ pkgs,...}:
{
# kernel - cachyos(1) or zen(2)
  #boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [ "quiet" "splash" "udev.log_priority=3" ];
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = false;
  boot.kernel.sysctl = {
  "vm.vfs_cache_pressure" = 50;  # default 100, keeps file cache longer
  "vm.dirty_ratio" = 10;
  "vm.dirty_background_ratio" = 5;
  };
  powerManagement.cpuFreqGovernor = "schedutil";
  services.udev.extraRules = ''
  ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="mq-deadline"
  '';

  boot.blacklistedKernelModules = [
  "joydev"             # joystick - xbox controller on wayland doesn't use this
  "mousedev"           # legacy mouse interface - wayland uses evdev
  "mac_hid"            # mac HID compat layer - you're not on a mac lol
  "serio_raw"          # raw serio interface - nothing needs it
  "8250_dw"            # designware serial UART - not needed
  "snd_seq_dummy"      # dummy midi sequencer
  "dmi_sysfs"          # dmi info via sysfs - not critical
  "intel_powerclamp"   # intel cpu power clamping - earlyoom handles pressure instead
  "tiny_power_button"  # alternative power button handler - redundant
  "ahci"
  "libahci"
];
}
