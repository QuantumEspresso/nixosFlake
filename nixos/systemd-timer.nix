{ config, pkgs, ... }:
{
  config = {
    systemd.timers."wallpaper" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "wallpaper.service";
      };
    };

    systemd.services."wallapaper" = {
      path = [pkgs.swww];
      script = ''


      '';
      serviceConfig = {
        Type = "oneshot";
        User = "norbert";
      };
    };
  };
}
