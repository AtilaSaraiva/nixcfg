{ ... }:

{
  imports = [
    ./network.nix
  ];

  services.logind.lidSwitch = "suspend";
}
