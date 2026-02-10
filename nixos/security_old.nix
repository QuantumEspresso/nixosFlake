{
  lib,
  config,
  pkgs,
  ...
}: {
  # # automatically upgrade system
  # system.autoUpgrade = {
  #   enable = true;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L" # print build logs
  #   ];
  #   dates = "02:00";
  #   randomizedDelaySec = "45min";
  # };

  # automatically clear old generations
  nix.gc = {
    automatic = true;
    persistent = false;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Yubikey setup for passwordless login and root
  security.pam.services = {
    login.u2fAuth = true; # somehow works well on gdm, but not on sddm :(
    sudo.u2fAuth = true;
  };

  # Yubikey settings in u2f pam module
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    #control = "required";
    settings.authfile = pkgs.writeText "u2f-auth-file" ''
      norbert:T4vd6QNqSw8GpMFmygwPXOKCMbqbMY6tEUj8MOPXHIYDddilHrPtzKeAd9xRhJDCQdcWqXw4/EgLRZO6NsIP/Q==,XXDi7y5cpMcwYbciPpqdLokO4HxnqWWclXpO6TD/Ezs146yY8B84umrLGPgK1ICz4PdjAIaUtR1ExAGsX6I6GA==,es256,+presence
    '';
  };

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  programs.ssh.startAgent = false;

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

}
