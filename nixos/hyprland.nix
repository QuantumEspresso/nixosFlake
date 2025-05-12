{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{

  config = {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
      xwayland.hidpi = true;

      # enableNvidiaPatches = true;

      # Optional
      # Whether to enable patching wlroots for better Nvidia support
      #enableNvidiaPatches = true;
    };
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    #xdg = {
    #  autostart.enable = true;
    #  portal = {
    #    enable = true;
    #    extraPortals = [
    #      pkgs.xdg-desktop-portal-gtk
    #      #pkgs.xdg-desktop-portal-hyprland
    #    ];
    #  };
    #};

    environment.systemPackages = with pkgs; [
      kitty
      polkit_gnome
      libva-utils
      fuseiso
      udiskie
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      khal
      zathura
      libsForQt5.dolphin
      unstable.conky
      imagemagick
      playerctl
      rofi-wayland
      rofi-file-browser
      rofi-calc
      rofi-top
      rofimoji
      rofi-power-menu
      ponymix
      qrencode
      surfraw
      bmon
      dunst
      pywal
      colorz
      i3lock-color
      bc
      jq
      wlr-randr
      ydotool
      wl-clipboard
      cliphist
      hyprland-protocols
      hyprland-per-window-layout
      hyprpicker
      swayidle
      swaylock
      hyprpaper # deprecated, not used
      firefox-wayland
      qt5.qtwayland
      swww
      swaybg
      mpvpaper
      waypaper
      wireplumber
      wf-recorder
      obs-studio
      xwaylandvideobridge
      grim
      slurp
      swappy
      gromit-mpx
      xdg-utils
      xdg-desktop-portal-hyprland
      hyprland-autoname-workspaces
      eww
      hyprcursor
    ];
  };

}

