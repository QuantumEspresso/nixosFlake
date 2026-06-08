{ config, pkgs, lib, ... }:

let
  yubikeyPubKey = ../keys/pub.key;
  yubikeyU2fKey = ../keys/u2f_keys;
in
{
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
    ];
  };
  
  home-manager.users.quantum = {
    config,
    pkgs,
    ...
  }: {
    home.stateVersion = "25.11";

############  GPG and SSH Yubikey config   ####################
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
    
    home.file.".config/Yubico/u2f_keys".source = yubikeyU2fKey;

##############  dot files   ######################

    home.activation.cloneDotfiles = ''
      set -e

      HYPR_DIR="$HOME/.config/hypr"
      QUICKSHELL_DIR="$HOME/.config/quickshell"

      if [ ! -d "$HYPR_DIR/.git" ]; then
        echo "Cloning hyprland_config..."
        ${pkgs.git}/bin/git clone https://github.com/QuantumEspresso/hyprland_config "$HYPR_DIR"
      fi

      if [ ! -d "$QUICKSHELL_DIR/.git" ]; then
        echo "Cloning quickshell..."
        ${pkgs.git}/bin/git clone https://github.com/QuantumEspresso/quickshell "$QUICKSHELL_DIR"
      fi
    '';

    home.activation.dotfilesRepo = ''
      set -e

      REPO_DIR="$HOME/Projects/dotfiles"
      REPO_URL="https://github.com/QuantumEspresso/dotfiles"

      if [ ! -d "$REPO_DIR/.git" ]; then
        echo "Cloning dotfiles repo..."
        ${pkgs.git}/bin/git clone "$REPO_URL" "$REPO_DIR"
      else
        echo "Updating dotfiles repo..."
        ${pkgs.git}/bin/git -C "$REPO_DIR" pull --ff-only
      fi
    '';

    home.activation.dotfilesSymlinks = ''
      set -e

      DOTFILES="$HOME/Projects/dotfiles"

      mkdir -p "$HOME/.config"

      for d in cava alacritty matugen; do
        TARGET="$HOME/.config/$d"
        SOURCE="$DOTFILES/$d"

        if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
          rm -rf "$TARGET"
        fi

        ln -sfn "$SOURCE" "$TARGET"
      done
    '';

###############   PROGRAMS   ######################

    programs.vscode = {
      enable = true;

      package = pkgs.vscode.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=UseOzonePlatform"
        ];
      };

      #package = pkgs.vscode; # albo pkgs.vscodium

      extensions = with pkgs.vscode-extensions; [
        ms-vscode.live-server
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
      ];
    };

  };
}
