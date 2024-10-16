{ pkgs, ... }:

{
  services.slurm = {
    server.enable = true;
    controlMachine = "igris";
  };
}
