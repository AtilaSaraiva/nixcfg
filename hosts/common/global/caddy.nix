{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.fin-shaula.ts.net".extraConfig = ''
      reverse_proxy localhost:8096
    '';
  };

  services.tailscale.permitCertUid = "caddy";
}
