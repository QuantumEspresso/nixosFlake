{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  }
}:

pkgs.mkShell {

  name = "air-wine32";

  buildInputs = with pkgs; [

    wineWowPackages.stable
    winetricks

    curl
    cabextract

    # 32-bit multimedia support
    pkgsi686Linux.gst_all_1.gstreamer
    pkgsi686Linux.gst_all_1.gst-plugins-base
    pkgsi686Linux.gst_all_1.gst-plugins-good
    pkgsi686Linux.gst_all_1.gst-plugins-bad

  ];


  shellHook = ''

    echo ">>> Konfiguracja AIR pod Wine environment"


    # =====================================
    # WINE
    # =====================================

    export WINEARCH=win32
    export WINEPREFIX="$HOME/.wine-air"

    export WINEESYNC=0
    export WINEFSYNC=0


    # Nie włączamy:
    # WINEDEBUG
    # LARGE_ADDRESS_AWARE
    # DLL overrides


    # =====================================
    # CREATE PREFIX
    # =====================================

    if [ ! -f "$WINEPREFIX/system.reg" ]; then

      echo ">>> Tworzenie 32-bitowego prefixu..."

      WINEARCH=win32 \
      WINEPREFIX="$WINEPREFIX" \
      wineboot

      echo ">>> Prefix gotowy."
      echo ">>> Restart nix-shell."

      return 0

    fi



    # =====================================
    # WINETRICKS
    # =====================================

    echo ">>> Instalacja runtime..."

    winetricks -q settings win7

    winetricks -q \
      vcrun2010 \
      gdiplus \
      corefonts



    # =====================================
    # ADOBE AIR
    # =====================================

    AIR="$HOME/.cache/air/AdobeAIRInstaller.exe"

    mkdir -p "$(dirname "$AIR")"


    if [ ! -f "$AIR" ]; then

      echo ">>> Pobieranie Adobe AIR..."

      curl -L \
      -o "$AIR" \
      https://archive.org/download/adobe-airinstaller/AdobeAIRInstaller.exe

    fi



    if ! WINEPREFIX="$WINEPREFIX" wine reg query \
      "HKLM\\Software\\Adobe\\AIR" \
      >/dev/null 2>&1
    then

      echo ">>> Instalacja Adobe AIR..."

      WINEPREFIX="$WINEPREFIX" \
      wine "$AIR"

      echo ">>> AIR zainstalowany."

    else

      echo ">>> AIR już istnieje."

    fi



    echo ""
    echo "================================="
    echo " GOTOWE"
    echo ""
    echo "Uruchom:"
    echo "wine game.exe"
    echo "================================="


  '';

}