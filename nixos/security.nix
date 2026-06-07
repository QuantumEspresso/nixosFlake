{ config, pkgs, ... }:

{  
  environment.systemPackages = with pkgs; [
    # yubikey
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pcsc-tools
    opensc
    gnupg
    pinentry-qt
    #TPM
    tpm2-tools
  ];

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  
  services.pcscd.enable = true;

  # 2FA
  security.pam.services.login.u2fAuth = true;
  security.pam.services.sudo.u2fAuth = true;

  security.pam.u2f = {
    enable = true;
    settings.cue = true; # show notification
  };
  
  # sudo hardening
  security.sudo.execWheelOnly = true;
  
  # firewall
  networking.firewall.enable = true;
  
  #ssh
  services.openssh = {
    enable = true;

    settings = {
    PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  
  #kernel hardening
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
  };
  
  # system monitoring
  security.apparmor.enable = true;
  
  security.audit.enable = true;
  
  #TPM
  security.tpm2.enable = true;
  
  
}
