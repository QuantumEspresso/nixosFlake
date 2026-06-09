{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    brave
    gedit
    
    usbutils
    edid-decode
    drm_info
    libdrm
  ];

  programs.zsh.enable = true;
}
