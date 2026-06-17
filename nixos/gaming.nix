{ config, pkgs, pkgs-unstable, ... }:

{
  programs.steam.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    steam
    libpulseaudio
  ];

environment.sessionVariables = {
  STEAM_RUNTIME = "0";
};

environment.sessionVariables = {
  STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
};

}