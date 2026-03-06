{ pkgs, config, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."https://jellyfin.fin-shaula.ts.net:433".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
      '';
    virtualHosts."localhost".extraConfig = ''
      respond "Hello, world!"
    '';
    package = pkgs.caddy.withPlugins {
      plugins = [ 
        "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" 
      ];
      hash = "sha256-OydhzUGG3SUNeGXAsB9nqXtnwvD36+2p3QzDtU4YyFg=";
    };
  };

  services.caddy.environmentFile = /secrets/tailscale.env;


  services.tailscale.permitCertUid = "caddy";
}
