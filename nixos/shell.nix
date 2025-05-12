{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    shellAliases = {
      ll = "ls -l";
      vim = "nvim";
      reload="qtile cmd-obj -o cmd -f reload_config";
      restart="qtile cmd-obj -o cmd -f restart";
      logoff="pkill -KILL -u $USER";
      update = "sudo nixos-rebuild switch";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
    histSize = 10000;
    shellInit = ''
      wal -n -R -q && clear
    '';
  };
}
