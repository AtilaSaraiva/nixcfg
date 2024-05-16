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
  services.avahi.openFirewall = true;
  hardware.printers = {
    ensurePrinters = [
      {
        name = "BrotherDCPL2550DW";
        location = "Home";
        deviceUri = "ipp://10.0.0.132:631/ipp";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
          PrintQuality="4";
          PwgRasterDocumentType="SGray_8";
        };
      }
    ];
    ensureDefaultPrinter = "BrotherDCPL2550DW";
  };
}
