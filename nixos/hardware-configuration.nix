# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["amdgpu"];
    # boot.kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    supportedFilesystems = ["ntfs"];
  };

  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };
  #
  # services.xserver.videoDrivers = ["amdgpu"];

  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    amdgpu.opencl.enable = true;
    amdgpu.initrd.enable = lib.mkDefault true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b3152b6e-6e90-4638-8efb-93d10541853d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2EB2-9803";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/run/media/norbert/Dane" = {
    device = "/dev/disk/by-uuid/E074988F749869D4";
    fsType = "ntfs-3g";
    options = ["rw"];
  };

  fileSystems."/run/media/norbert/Windows" = {
    device = "/dev/disk/by-uuid/96806B58806B3DBD";
    fsType = "ntfs-3g";
    options = ["rw"];
  };

  fileSystems."/run/media/norbert/Games" = {
    device = "/dev/disk/by-uuid/BAC04B94C04B5633";
    fsType = "ntfs-3g";
    options = ["rw"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp12s0u6u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
