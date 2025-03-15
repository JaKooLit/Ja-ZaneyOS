{inputs, ...}: {
  imports = [
    ./boot.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    ./packages.nix
    ./security.nix
    ./services.nix
    ./starfish.nix
    ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./user.nix
    ./xdg.nix
    ./xserver.nix
    inputs.stylix.nixosModules.stylix
  ];
}
