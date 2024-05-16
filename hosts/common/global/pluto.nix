{ pkgs, ... }:

{
    systemd.user.services.pluto = {
    description = "Pluto.jl";
    script = ''
      JULIA_DEPOT_PATH=/home/atila/.julia ${pkgs.julia-bin}/bin/julia -e 'using Pluto; Pluto.run(launch_browser=false, host=read(`${pkgs.tailscale}/bin/tailscale ip --4`, String) |> strip |> string, require_secret_for_open_links=false, require_secret_for_access=false)'
    '';
    wantedBy = [ "default.target" ]; # starts after login
  };
}
