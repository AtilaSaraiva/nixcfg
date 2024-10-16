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

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common/global/amdgpu.nix
    ../common/global/bluetooth.nix
    ../common/global/defaults.nix
    ../common/global/flatpak.nix
    ../common/global/laptop.nix
    ../common/global/nix.nix
    ../common/global/noisetorch.nix
    ../common/global/printing.nix
    ../common/global/scanner.nix
    ../common/global/sound.nix
    ../common/global/sway.nix
    ../common/global/syncthing.nix
    ../common/global/virtualization.nix
    ../common/global/locate.nix
    ../common/global/quietboot.nix
    ../common/global/zram.nix
    ../common/global/verifyStore.nix
    ../common/global/tailscale.nix
    ../common/global/focusmode
    ../common/global/tmpfs.nix
    ../common/global/slurm.nix

    ../common/users/atila.nix
  ];

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "igris";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  i18n.defaultLocale = "pt_BR.UTF-8";

  time.timeZone = "America/Edmonton";

  # to prevent random freezes
  boot.kernelParams = [ "idle=nomwait" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.11";
}
