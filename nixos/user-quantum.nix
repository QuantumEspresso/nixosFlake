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
    shell = pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "storage"
      "video"
      "render"
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
      fzf
      starship
      zsh-autosuggestions
      zsh-syntax-highlighting
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

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        router = {
          hostname = "192.168.8.1";
          user = "root";
        };

        proxmox = {
          hostname = "192.168.8.50";
          user = "root";
        };

        wedding = {
          hostname = "192.168.8.51";
          user = "root";
        };

        ai = {
          hostname = "192.168.8.173";
          user = "quantum";
        };
      };
    };

    programs.vscode = {
      enable = true;

      package = pkgs.vscode.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=UseOzonePlatform"
        ];
      };

      #package = pkgs.vscode; # albo pkgs.vscodium

      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-vscode.live-server
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
      ];
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

programs.starship = {
  enable = true;
  enableZshIntegration = true;

  settings = {
    add_newline = false;

    # 🔥 segmentowy prompt jak statusline
    format = "$directory$git_branch$git_status$fill$cmd_duration$line_break$character";

    # --- DIRECTORY ---
    directory = {
      style = "bold cyan";
      truncation_length = 3;
      truncate_to_repo = true;
      read_only = "🔒";
    };

    # --- GIT BRANCH ---
    git_branch = {
      symbol = " ";
      style = "bold purple";
      format = "on [$symbol$branch]($style) ";
    };

    # --- GIT STATUS (mega ważne) ---
    git_status = {
      format = "([($all_status$ahead_behind)]($style) )";
      style = "bold red";

      conflicted = "✖";
      modified = "●";
      staged = "✔";
      untracked = "…";
      ahead = "⇡";
      behind = "⇣";
      diverged = "⇕";
    };

    # --- TIME / COMMAND DURATION ---
    cmd_duration = {
      min_time = 500;
      format = "took [$duration](yellow) ";
    };

    # --- PROMPT ARROW (statusline vibe) ---
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };

    # opcjonalnie: separator “statusline feel”
    fill = {
      symbol = " ";
    };
  };
};

    programs.zsh = {
      enable = true;

      enableCompletion = true;

      # --- HISTORY ---
      history = {
        size = 100000;
        save = 100000;
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
      };

      # --- ALIASES ---
      shellAliases = {
        ll = "ls -lah";
        la = "ls -A";

        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gpl = "git pull";

        ".." = "cd ..";
        "..." = "cd ../..";
      };

      # --- INIT ---
      initContent = ''
        # ========== PLUGINS ==========
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # ========== SHELL BEHAVIOR ==========
        setopt AUTO_CD
        setopt HIST_IGNORE_ALL_DUPS
        setopt SHARE_HISTORY
        setopt INC_APPEND_HISTORY

        # ========== BETTER COMPLETION ==========
        autoload -Uz compinit
        compinit

        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

        # ========== STATUS LINE ==========
        eval "$(starship init zsh)"
      '';
    };

  };
}
