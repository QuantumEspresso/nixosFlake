{ lib, fetchFromGitHub }:

let
  pname = "games_font";
  version = "1.0";
in fetchFromGitHub {
  name = "${pname}-${version}";
  
  owner = "dirdam";
  repo = "fonts";
  rev = "f196135147e52510a60abbb36288bd480cb138dd";
  hash = "sha256-5xEFFCzBH5s3849zn6m7191nrwHqrs7yGDRVtYwU+Xo=";

  meta = with lib; {
    description = "fonts pack from a few games: Zelda, Fez and Pokemon";
    longDescription = "This package contains unown font from Pokemon, Zuish font from Fez and Gerudo, Hylian and Sheikah fonts from Legend of Zelda: Breath of the Wild.";
    homepage = "https://github.com/dirdam/fonts";
    #license = licenses.ofl;
    platforms = platforms.all;
  };
}