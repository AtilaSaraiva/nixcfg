{ pkgs, ... }:

{
  hardware.sane = {
    enable = true;
    brscan5 = {
      enable = true;
      netDevices = {
        brother = {
          ip = "10.0.0.132";
          model = "DCP-L2550DW";
        };
      };
    };
    extraBackends = [ pkgs.sane-airscan ];
  };
}
