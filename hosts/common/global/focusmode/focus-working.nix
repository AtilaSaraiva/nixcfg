{ lib, config, ... }:

lib.mkIf (config.focusMode) {
  # Stuff that I should not open in the workstation
  networking.extraHosts = ''
    0.0.0.0 web.telegram.org
    0.0.0.0 discord.com
    0.0.0.0 web.whatsapp.com
    0.0.0.0 app.element.io
    0.0.0.0 youtube.com www.youtube.com
    0.0.0.0 instagram.com www.instagram.com
    0.0.0.0 twitter.com x.com
    0.0.0.0 amazon.ca www.amazon.ca
    0.0.0.0 amazon.com www.amazon.com
  '';
}
