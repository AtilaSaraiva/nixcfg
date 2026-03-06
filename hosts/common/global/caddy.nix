{ pkgs, config, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."localhost".extraConfig = ''
      respond "Hello, world!"
    '';
  };

  services.caddy.environmentFile = /secrets/tailscale.env;


  services.tailscale.permitCertUid = "caddy";
}
