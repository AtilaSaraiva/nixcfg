{ ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
    # resolvconf.enable = true;
    useDHCP = false;
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
