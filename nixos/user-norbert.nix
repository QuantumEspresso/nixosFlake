{
  config,
  pkgs,
  ...
}: let
  variables = import ./variable.nix;
in {
  # users cannot be modified outside this file
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.norbert = {
    isNormalUser = true;
    description = "Norbert";
    home = "/home/norbert";
    createHome = true;
    extraGroups = ["networkmanager" "wheel" "storage"];
    hashedPassword = "$6$sUTjGhSgqFFVB0ng$xs9ez/gF/BpcyFNlH4dkqfhbl9Zle/76Hjd9beuqRaeqlinaxfoNJmHSBZOkctr4W9QDmUSH/U5X2S5GbJwuE.";
    useDefaultShell = true;
    packages = with pkgs; [
      # utilities and tools
      git
      thefuck
      pywal
      steam-run
      ripgrep
      udisks
      ntfs3g
      mdadm
      tk
      htop
      btop
      radeontop
      nethogs
      lm_sensors
      fzf
      unzip
      pciutils
      curl
      rsync
      sshfs
      gnugrep
      pulseaudio
      pulsemixer
      p7zip
      killall
      cmatrix
      wireshark
      libgcc
      zlib
      appimage-run
      pdftk
      distrobox
      vpn-slice
      yt-dlp
      usbutils
      udiskie
      # terminal emulators
      alacritty
      ghostty
      tmux
      # browsers
      brave
      tor-browser
      firefox-unwrapped
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
      # communicators and media
      signal-desktop
      discord
      steam
      cmus
      vlc
      # everyday use
      ranger
      nautilus
      mc
      khal
      syncthing
      #      syncthing-tray
      gromit-mpx
      xsane
      keepassxc
    ];
  };

  home-manager.users.norbert = {
    config,
    pkgs,
    ...
  }: {
    home.stateVersion = "${variables.channelVersion}";

    services.udiskie = {
      enable = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 12;
        env = {
          "TERM" = "st-256color";
        };
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      #autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      initContent = ''pokemonsay Catch me if you can!'';
      sessionVariables = {
        EDITOR = "nvim";
        GPG_TTY = "tty";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "branch"
          #  "docker"
          "colorize"
          "emoji"
          "git"
          "gpg-agent"
          "history-substring-search"
          "kitty"
          "kubectl"
          "sudo"
          "systemadmin"
          "thefuck"
          #  "vi-mode"
        ];
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ll = "ls -l";
        vim = "nvim";
      };
      sessionVariables = {
        EDITOR = "nvim";
        GPG_TTY = "tty";
      };
      #bashrcExtra =
      #''neofetch '';
    };

    programs.gpg = {
      enable = true;

      # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      scdaemonSettings = {
        disable-ccid = true;
      };

      publicKeys = [
        {
          text = ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----

            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
            HLw=
            =ZKOK
            -----END PGP PUBLIC KEY BLOCK-----
          '';
          trust = 5;
        }
      ];

      # https://github.com/drduh/config/blob/master/gpg.conf
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };

    services.gpg-agent = {
      enable = true;

      # https://github.com/drduh/config/blob/master/gpg-agent.conf
      defaultCacheTtl = 60;
      enableSshSupport = true;
      enableExtraSocket = true;
      maxCacheTtl = 120;
      pinentry.package = pkgs.pinentry-curses;
      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };

    programs.git = {
      enable = true;
      userName = "Norbert Janik";
      userEmail = "norbert.janik@protonmail.com";
      signing.key = "9CE2153C123CBA9F";
      extraConfig.commit.gpgsign = true;
    };
  };
}
