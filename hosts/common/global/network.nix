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

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

}
