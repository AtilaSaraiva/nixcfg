{ pkgs, ... }:

{
  imports = [
    ./network.nix
  ];


  programs.sway.extraPackages = with pkgs; [
    brightnessctl
    acpi
  ];

  services.auto-cpufreq.enable = true;

  services.logind.lidSwitch = "suspend";

  powerManagement.cpuFreqGovernor = "ondemand";
}
