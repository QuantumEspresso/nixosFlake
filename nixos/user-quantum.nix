{ config, pkgs, lib, ... }:

let
  yubikeyPubKey = ../keys/pub.key;
in
{

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  
  services.pcscd.enable = true;
  
  users.mutableUsers = false;
  users.users.quantum = {
    isNormalUser = true;
    description = "quantum";

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "storage"
    ];

    # security
    hashedPassword = "$6$sUTjGhSgqFFVB0ng$xs9ez/gF/BpcyFNlH4dkqfhbl9Zle/76Hjd9beuqRaeqlinaxfoNJmHSBZOkctr4W9QDmUSH/U5X2S5GbJwuE.";

    packages = with pkgs; [
    
      # terminal stuff
      git
      steam-run
      cmatrix
      appimage-run
      pdftk
      yt-dlp
      ranger
      neovim
      # browsers
      brave
      firefox-unwrapped
      tor-browser
      lynx
      # funny shit
      pokemon-colorscripts-mac
      pokemonsay
      pokemon-cursor
      # office etc
      libreoffice-qt-fresh
      texstudio
      texliveFull
      xournalpp
      krita
      gedit
      gimp-with-plugins
      audacity
      evince
      shotwell
      # communicators and media
      signal-desktop
      discord
      steam
      cmus
      vlc
      spotify
      # other
      syncthing
      # syncthing-tray
      keepassxc
      # security
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      pcsc-tools
      opensc
      gnupg
      pinentry-qt
    ];
  };
  
  home-manager.users.quantum = {
    config,
    pkgs,
    ...
  }: {
    home.stateVersion = "25.11";

    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Norbert Janik";
          email = "norbert.janik@protonmail.com";
        };

        gpg.program = "gpg";
      };

      signing = {
        key = "DAB2EB329C21DF827535E63F2B54798C1B2947BE";
        signByDefault = true;
      };
    };

    home.activation.importGpgPubkey = ''
      if ! ${pkgs.gnupg}/bin/gpg \
           --list-keys DAB2EB329C21DF827535E63F2B54798C1B2947BE \
           >/dev/null 2>&1; then

        echo "Importing YubiKey public key..."

        ${pkgs.gnupg}/bin/gpg --batch --import ${yubikeyPubKey}
      fi
    '';
    home.activation.gpgTrust = ''
      ${pkgs.gnupg}/bin/gpg --import-ownertrust <<EOF
      DAB2EB329C21DF827535E63F2B54798C1B2947BE:6:
      EOF
    '';

  };
}
