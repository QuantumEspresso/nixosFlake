{ config, pkgs, lib, ... }:

{
  ##########################
  # OpenSSH
  ##########################
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    # Dodatkowa konfiguracja w postaci pliku sshd_config
    extraConfig = ''
      PubkeyAuthentication yes
      # Opcjonalnie inne parametry, np. AuthorizedKeysFile
    '';
  };
  ##########################
  # YubiKey / GPG agent
  ##########################
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true; # udostępnia klucze GPG dla ssh-agent
  };

  programs.ssh.startAgent = false; # wyłączamy domyślny ssh-agent, używamy gpg-agent

  ##########################
  # PC/SC daemon do YubiKey / FIDO
  ##########################
  services.pcscd.enable = true;

  ##########################
  # PAM U2F / YubiKey dla logowania lokalnego
  ##########################
  security.pam.u2f = {
    enable = true;
    control = "sufficient"; # "required" jeśli chcesz wymusić zawsze
    settings.authfile = pkgs.writeText "u2f-auth-file" ''
      norbert:T4vd6QNqSw8GpMFmygwPXOKCMbqbMY6tEUj8MOPXHIYDddilHrPtzKeAd9xRhJDCQdcWqXw4/EgLRZO6NsIP/Q==,XXDi7y5cpMcwYbciPpqdLokO4HxnqWWclXpO6TD/Ezs146yY8B84umrLGPgK1ICz4PdjAIaUtR1ExAGsX6I6GA==,es256,+presence
    '';
  };

  # Jeśli chcesz włączyć u2f dla login i sudo:
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  ##########################
  # Pakiety potrzebne
  ##########################
  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  # PC/SC dla YubiKey wymaga udev rules
  services.udev.packages = [ pkgs.yubikey-personalization ];

  ##########################
  # SSH_AUTH_SOCK w sesjach nie-interaktywnych
  ##########################
  # Opcjonalnie, jeśli chcesz żeby sesje SSH widziały agent GPG:
  environment.variables.SSH_AUTH_SOCK = "${pkgs.gnupg}/libexec/gpg-agent-ssh-socket";
}
