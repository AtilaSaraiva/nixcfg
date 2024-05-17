{ ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    firewall = {
      enable = false;
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
    };
    resolvconf.enable = true;
    useDHCP = false;
  };
}
