{ ... }:

{
  services.printing = {
    enable = true;
    startWhenNeeded = false;
    browsing = false;
    drivers = [ ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = false;
}
