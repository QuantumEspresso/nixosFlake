{
  lib,
  config,
  pkgs,
  ...
}: {
  # automatically upgrade system
  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # automatically clear old generations
  nix.gc = {
    automatic = true;
    persistent = false;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # allow users to use sudo without password
  #  security.sudo.extraRules= [
  #    {
  #      #users = [ "norbert" ];
  #      commands = [
  #        { command = "${pkgs.nethogs}/bin/nethogs" ;
  #          options= [ "SETENV" "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
  #        }
  #      ];
  #      groups = [ "wheel" ];
  #    }
  #  ];

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
