{ config, pkgs, pkgs-unstable, ... }:

{
  # ------------------------------------------------------------
  # SYSTEM BASE PACKAGES
  # ------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    vim
    jq

    # LLM tooling
    llama-cpp

    # debugging GPU / system
    pciutils
    usbutils

    # network debug
    iperf3
    openssl

    # ROCm tools (AMD)
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    rocmPackages.clr
    rocmPackages.rocblas
    rocmPackages.rocsparse
  ];


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

  networking.enableIPv6 = false;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  services.resolved.enable = false;

  # ------------------------------------------------------------
  # MODELS PARTITION ACCESS
  # ------------------------------------------------------------

  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /data/ollama 0755 ollama ollama -"
  ];

  systemd.services.fix-ollama-data-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      mkdir -p /data/ollama
      chown -R ollama:ollama /data/ollama
    '';
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
  # GPU / ACCELERATION BASELINE
  # ------------------------------------------------------------

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ------------------------------------------------------------
  # OLLAMA (core LLM runtime)
  # ------------------------------------------------------------
  services.ollama = {
    enable = true;

    package = pkgs-unstable.ollama-rocm;

    home = "/data/ollama";

    # ważne: LAN access
    host = "0.0.0.0";
    port = 11434;

    # backend acceleration (zmień jeśli trzeba)
    # acceleration = "rocm";  # "cuda" / null / rocm
  };

  # ------------------------------------------------------------
  # OPEN WEB UI (chat interface)
  # ------------------------------------------------------------
  services.open-webui = {
    enable = true;

    package = pkgs-unstable.open-webui;

    host = "0.0.0.0";
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      ENABLE_SIGNUP = "true";
      ENABLE_WEB_SEARCH = "true";
      WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://127.0.0.1:8081/search";
    };

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
        limiter = false;
        secret_key = "8855c6d5898e2d49b63275c8d6a0c23c1f983238dea2f549670ffaf399ace6b7";
      };

      search = {
        safe_search = 0;
        formats = [
          "html"
          "json"
        ];
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

  # ------------------------------------------------------------
  # LAN VISIBILITY CONFIGURATION
  # ------------------------------------------------------------
  services.nginx = {
    enable = true;

    virtualHosts."ai.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };

      locations."/ollama/" = {
        proxyPass = "http://127.0.0.1:11434";
      };

      locations."/search/" = {
        proxyPass = "http://127.0.0.1:8081";
      };
    };
  };

  # host name in network
  networking.hostName = "NixAI"; # Define your hostname.
}
