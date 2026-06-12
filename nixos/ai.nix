{ config, pkgs, pkgs-unstable, ... }:

{
  # ------------------------------------------------------------
  # NETWORK / LAN ACCESS
  # ------------------------------------------------------------
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22     # SSH
      11434  # Ollama API
      8080   # Open WebUI
      8081   # SearXNG
    ];
  };

  # ------------------------------------------------------------
  # SSH SERVER (remote maintenance over LAN)
  # ------------------------------------------------------------
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = true;   # możesz zmienić na false później
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # ------------------------------------------------------------
  # SYSTEM BASE PACKAGES
  # ------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    vim

    # LLM tooling
    llama-cpp

    # debugging GPU / system
    pciutils
    usbutils

    # network debug
    iperf3
  ];

  # ------------------------------------------------------------
  # GPU / ACCELERATION BASELINE
  # ------------------------------------------------------------
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # ROCm tools (AMD)
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];

  # ------------------------------------------------------------
  # OLLAMA (core LLM runtime)
  # ------------------------------------------------------------
  services.ollama = {
    enable = true;

    # ważne: LAN access
    host = "0.0.0.0";
    port = 11434;

    # backend acceleration (zmień jeśli trzeba)
    acceleration = "rocm";  # "cuda" / null / rocm
  };

  # ------------------------------------------------------------
  # OPEN WEB UI (chat interface)
  # ------------------------------------------------------------
  services.open-webui = {
    enable = true;

    host = "0.0.0.0";
    port = 8080;
  };

  # ------------------------------------------------------------
  # SEARXNG (tool for LLM internet access)
  # ------------------------------------------------------------
  services.searx = {
    enable = true;

    settings = {
      server = {
        bind_address = "0.0.0.0";
        port = 8081;
        secret_key = "change-me-please"; # wymagane
      };

      search = {
        safe_search = 0;
      };
    };
  };

  # ------------------------------------------------------------
  # OPTIONAL: performance tuning for LLM workloads
  # ------------------------------------------------------------
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  # ------------------------------------------------------------
  # USER EXPERIENCE (opcjonalne, ale praktyczne)
  # ------------------------------------------------------------
  services.tailscale.enable = false; # możesz włączyć później

  # host name in network
  networking.hostName = "NixAI"; # Define your hostname.
}