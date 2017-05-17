# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

# Boot conf
  boot={

    # Kernel modules choices :
    kernelModules = [
      "fbcon" # framebuffer console supports high resolutions, varying font types, display rotation, primitive multihead, etc
      "i915" # linux kernel driver for intel chips
      "acpi-cpufreq" # CPU frequency scaling infrastructure
      "cpufreq-ondemand" # Normally loaded automatically with acpi-cpufreq
      "coretemp" # driver that permits reading tje Digital Temperature Sensor of intel CPUs
      "battery" # driver for battery informations
      "xhci-hcd" # USB 3.0 supports
      "uvcvideo" # driver for Webcam, Video grabber devices
      "snd-hda-intel power_save=5 index=1,0" # audio driver
      "snd-pcm"
      "kvm-intel"
      "aesni-intel"
      "crc32c-intel"
      "intel-powerclamp"
      "ath9k"
      "asus-nb-wmi"
    ];
    extraModulePackages = [ config.boot.kernelPackages.bbswitch ];
    initrd = {
      kernelModules = [
        "fbcon"
        "i915"
        "ehci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      network.enable = true;
    };
  };

  ## Change linux kernel default :
  #boot.kernelPackages = pkgs.linuxPackages_4_9;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  #boot.loader.gummiboot.timeout=null; # To boot automatically on the current generation
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c1e4dac6-244c-4128-aaf6-57cb03530d64";
      fsType = "ext4";
    };
  fileSystems."/run/media/D" =
    { device = "/dev/disk/by-uuid/19990B7D65A3ADFC";
      fsType = "ntfs";
    };


  # Authorize virtualization
  virtualisation.virtualbox.host.enable = true;

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.synaptics.minSpeed = "0.7";
  services.xserver.synaptics.maxSpeed = "3";
  services.xserver.synaptics.accelFactor = "0.05";

  hardware.bumblebee.enable = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # compatibility bluetooth & pulseaudio :
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # to get pulseaudio bluetooth
  nixpkgs.config = {
    packageOverrides = pkgs: {
    bluez = pkgs.bluez5;
    };
  };
  hardware.bluetooth.enable = true;

  powerManagement.scsiLinkPolicy = null; # SCSI : Small Computer System Interface (sd card lecteur / DVD / ...)

  swapDevices = [ ];

  nix.maxJobs = 4;
}
