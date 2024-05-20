{ pkgs, ... }:

{
  xdg.portal = {
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
        ];
      };
    };
  };

  # I need this to configure sway from home-manager in the future
  security.polkit.enable = true;

  security.pam.services.swaylock = { };
}
