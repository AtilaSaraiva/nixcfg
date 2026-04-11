{
  inputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # Or modules exported from other flakes (such as nix-colors):
    inputs.steamcmd-servers.nixosModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.steamcmd-servers.overlays.default
    ];
  };

  environment.systemPackages = [
    pkgs.steamcmd-ctl
  ];

  services.steamcmd-servers = {
    enable = true;
    openFirewall = true;

    servers = {
      pal = {
        enable = true;
        appId = "2394010";
        appIdName = "Palworld Dedicated Server";

        executable = "run-wrapper.sh";

        preStart = ''
          cat << 'EOF' > run-wrapper.sh
          #!/bin/sh
          # Use steam-run to provide the FHS environment for the unpatched script/binary
          exec ${pkgs.steam-run}/bin/steam-run ./PalServer.sh "$@"
          EOF
          
          chmod +x run-wrapper.sh
        '';

        executableArgs = [
          "-useperfthreads"
          "-NoAsyncLoadingThread"
          "-UseMultithreadForDS"
          "EpicApp=Pau"
        ];
        ports = {
          game = 8211;
          query = 27015;
        };
        environment = {
          LD_LIBRARY_PATH = "./linux64";
        };
        resources.memoryLimit = "16G";
        resources.cpuQuota = "800%";
      };
    };
  };
}
