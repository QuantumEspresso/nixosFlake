# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: let
  variables = import ./variable.nix;
in {
  # allow flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./grub.nix
    ./virtualisation.nix
    ./networking.nix
    ./misc.nix
    ./security.nix
    ./shell.nix
    ./system-packages.nix
    ./environment.nix
    ./user-norbert.nix
    ./nvf-configuration.nix
    #./ags-configuration.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${variables.channelVersion}"; # Did you read the comment?
}
