{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pcsc-tools
    opensc
    gnupg
    pinentry-qt
  ];

  # =========================
  # GPG + YUBIKEY (CORE FIX)
  # =========================

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # PCSC (POPRAWNIE)
  services.pcscd.enable = true;


  environment.sessionVariables = {
    GNUPG_NO_KEYBOXD = "1";
  };
}