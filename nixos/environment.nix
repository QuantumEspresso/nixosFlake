{ pkgs, pkgs-unstable, qylock, ... }:
let
  games-font = pkgs.callPackage ./games_font.nix {};
  
  pixel-munchlax = pkgs.stdenvNoCC.mkDerivation {
    pname = "pixel-munchlax";
    version = "git";

    src = qylock;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/pixel-munchlax
      cp -r $src/themes/pixel-munchlax/. \
        $out/share/sddm/themes/pixel-munchlax/
    '';
  };
in {
  # Time / locale
  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  # Display stack
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "pixel-munchlax";
    
    extraPackages = with pkgs; [
      qt6.qtdeclarative
      qt6.qt5compat
    ];
  };

  programs.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
    xwayland.enable = true;
  };

  # Qt / QML runtime fix for Quickshell
  environment.sessionVariables = {
    QT_PLUGIN_PATH =
      "${pkgs.qt6.qtbase}/lib/qt-6/plugins";

    QML2_IMPORT_PATH =
      "${pkgs.qt6.qt5compat}/lib/qt-6/qml:"
      + "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";

    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    
    GSETTINGS_SCHEMA_DIR =
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}/glib-2.0/schemas";
  };

  environment.systemPackages = with pkgs; [
    seahorse

    # Terminals
    alacritty
    kitty

    # Clipboard / utilities
    wl-clipboard
    cliphist
    curl

    # Hyprland ecosystem
    kanshi
    udiskie
    bluez
    libnotify
    hyprsunset
    hyprpicker
    hyprlock
    swww
    lm_sensors
    jq
    desktop-file-utils
    shared-mime-info

    # Media / audio
    playerctl
    brightnessctl
    pamixer
    pavucontrol
    pulseaudio
    cava
    cmus
    vlc

    # Networking
    networkmanager

    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gvfs

    # Screenshots / recording
    grim
    slurp
    gpu-screen-recorder

    # Tools
    pandoc
    pkgs-unstable.matugen
    binutils
    khal
    btop
    wayscriber
    libinput
    usbutils
    evtest

    # GPU monitors
    nvtopPackages.full

    # Quickshell + Qt
    quickshell
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtquicktimeline
    qt6.qt5compat
    qt6.qtmultimedia
    ffmpeg
    
    # GTK / gsettings
    glib
    dconf
    gsettings-desktop-schemas
    gtk3
    gtk4
    nwg-look

    # GTK themes
    gnome-themes-extra
    adwaita-icon-theme

    # icons
    papirus-icon-theme

    # Qt theming
    libsForQt5.qt5ct
    qt6Packages.qt6ct

    kdePackages.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum

    # Kvantum themes
    catppuccin-kvantum
    whitesur-kde
    
    # custom themes
    pixel-munchlax
  ];

  # theme settings for GTK and Qt
  programs.dconf.enable = true;
  services.dbus.enable = true;
  
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };
  
  
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
        color-scheme = "prefer-dark";
      };
    }
  ];
  
  # Fonts
  fonts.fontconfig.enable = true;
    # system fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    material-symbols
    material-design-icons
    games-font
  ];

  # File portals / Wayland integration
  xdg.portal.enable = true;

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # USB automount / trash / network mounts
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;
  
  # battery profiles management for laptop
  services.power-profiles-daemon.enable = true;
}
