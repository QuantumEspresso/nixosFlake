{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  environment.shells = with pkgs; [ bashInteractive zsh ];

  # session manager
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;

  # hyprland setup
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # automount devices (needs udiskie in home-manager to work)
  services.udisks2.enable = true;
  
  # wyaland support for Electron apps like Chromium based browsers
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # share screen possibility on Wayland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
