{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    input = {
      General = {
        UserspaceHID=true;
        ClassicBondedOnly=false; # necessary for dualshock controllers
      };
    };
  };
  services.blueman.enable = true;
}
