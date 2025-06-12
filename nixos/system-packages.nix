{
  config,
  pkgs,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    unstable.conky
    gnat
    bluez
    bluez-tools
    blueman
    networkmanager
    networkmanagerapplet
    openconnect
    networkmanager-openconnect
    pavucontrol
    bc
    ntfs3g

    # packages for hyprland
    kitty
    waybar
    dunst
    libnotify
    hyprpaper
    pyprland
    hyprshot
    hyprlock
    hypridle
    hyprpicker
    hyprcursor
    hyprland-protocols
    xdg-desktop-portal-hyprland
    kanshi

    #ags
    graphene
    gtk4
    nodejs
    gobject-introspection

    #tools
    evince
  ];
}
