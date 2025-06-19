# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    outputs.nixosModules.amdgpu
    outputs.nixosModules.qbittorrent-cli
    outputs.nixosModules.updateInputs

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common/global/amdgpu.nix
    ../common/global/bluetooth.nix
    ../common/global/defaults.nix
    ../common/global/flatpak.nix
    ../common/global/nix.nix
    ../common/global/noisetorch.nix
    ../common/global/syncthing.nix
    ../common/global/printing.nix
    ../common/global/scanner.nix
    ../common/global/network.nix
    ../common/global/sound.nix
    ../common/global/sway.nix
    ../common/global/virtualization.nix
    ../common/global/locate.nix
    ../common/global/quietboot.nix
    ../common/global/zram.nix
    ../common/global/verifyStore.nix
    ../common/global/jellyfin.nix
    ../common/global/komga.nix
    ../common/global/tailscale.nix
    ../common/global/nix-serve.nix
    ../common/global/focusmode
    ../common/global/tmpfs.nix
    ../common/global/pluto.nix
    ../common/global/btrfs.nix

    ../common/users/atila.nix
  ];

  # TODO: Set your hostname
  networking.hostName = "juroscomposto";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/Edmonton";

  services.amdgpu-fan = {
    enable = true;
    settings ={
      speed_matrix = [
        [0 0]
        [40 40]
        [60 60]
        [70 70]
        [80 90]
      ];
      temp_drop = 8;
    };
  };

  system.autoUpgrade = {
    operation = "switch";
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
  };

  services.qbittorrent = {
    enable = true;
    user = "atila";
    port = 35910;
    openFirewall = true;
  };

  services.updateInputs = {
    enable = true;
    flake_path = "/home/atila/Files/Codigos/repos/nixcfg";
  };

  gaming = {
    enable = true;
    hardwareConfiguration = ./hardware-configuration.nix;
  };

  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 1;
    "vm.dirty_background_ratio" = 1;
  };

  services.preload.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.05";
}
