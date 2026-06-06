To update flake:
nix flake update

To update sysetm with flake file (repo in ~/Documents):
nixos-rebuild switch --flake ~/Documents/nixosFlake#masyaf

To update channel to new one flake.nix and nixos/user-*.nix must be edited
