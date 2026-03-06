{ ... }:

{
  services.caddy = {
    enable = true;
    globalConfig = ''
      # This tells Caddy to use Tailscale for certs
      tailscale_allow_external_config
    '';
    virtualHosts."jellyfin.fin-shaula.ts.net".extraConfig = ''
      reverse_proxy localhost:8096
    '';
  };

  services.tailscale.permitCertUid = "caddy";
}
