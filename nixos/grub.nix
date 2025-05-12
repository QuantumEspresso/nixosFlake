{ config, pkgs, ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      configurationLimit = 10;
      enable = true;
      useOSProber = true;
#        theme = pkgs.fetchFromGitHub { # current as of 07/2023
#          owner = "shvchk";
#          repo = "fallout-grub-theme";
#          rev = "fcc680d166fa2a723365004df4b8736359d15a62";
#          sha256 = "sha256-dQYQYBL4RxxqCwN6V6DUiiPl7cQFNt/PH7ubpKA3YCg=";
#        };
      theme = "${
        (pkgs.fetchFromGitHub {
          owner = "13atm01";
          repo = "GRUB-Theme";
          rev = "95bcc240162bce388ac2c0bec628b2aaa56e6cb8";
          sha256 = "0xnx82fdyjqw89qmacwmlva9lis3zs8b0l1xi67njpypjy29sdnc";
        })
      }/Monika\ (Doki\ Doki\ Literature\ Club)/Monika-DDLC-Version/";
    };
    timeout = 10;
  };

  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "kvm-amd" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
}