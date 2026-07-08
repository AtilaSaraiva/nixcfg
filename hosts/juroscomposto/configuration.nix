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
    ../common/global/virtualization
    ../common/global/locate.nix
    ../common/global/quietboot.nix
    ../common/global/zram.nix
    ../common/global/verifyStore.nix
    # ../common/global/jellyfin.nix
    # ../common/global/gitea.nix
    # ../common/global/ollama.nix
    # ../common/global/palworld.nix
    ../common/global/msmtp.nix
    ../common/global/smartd.nix
    # ../common/global/komga.nix
    ../common/global/caddy.nix
    ../common/global/qui.nix
    ../common/global/tailscale.nix
    ../common/global/nix-serve.nix
    ../common/global/focusmode
    ../common/global/tmpfs.nix
    ../common/global/pluto.nix
    ../common/global/btrfs.nix
    # ../common/global/sunshine.nix

    ../common/users/atila.nix
  ];

  # TODO: Set your hostname
  networking.hostName = "juroscomposto";

  networking.firewall = {
    # TEMP(debug): 22 opens SSH over LAN for VFIO debugging. Normally SSH is
    # reachable only via tailscale0 (trustedInterfaces in network.nix). Remove
    # the 22 when done.
    allowedTCPPorts = [ 22 80 443 16770 5900 5901];
    allowedUDPPorts = [ 16770 ];
  };

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

  services.qbittorrentDaemon = {
    enable = true;
    user = "atila";
    port = 35910;
    openFirewall = false;
  };

  services.updateInputs = {
    enable = false;
    flake_path = "/home/atila/Files/Codigos/repos/nixcfg";
  };

  gaming = {
    enable = true;
    hardwareConfiguration = ./hardware-configuration.nix;
  };

  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 1;
    "vm.dirty_background_ratio" = 1;
    "kernel.split_lock_mitigate" =0;
  };

      # Sets the kernel parameters, equivalent to editing /etc/sysconfig/grub
      # Only enable the IOMMU here. For SINGLE-GPU passthrough we deliberately do
      # NOT set "vfio-pci.ids=" — that would bind the GPU to vfio at boot and
      # leave the host with no display. The libvirt hooks (gpuPassthrough below)
      # detach the GPU from amdgpu and bind vfio only when the VM starts.
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # Single-GPU passthrough libvirt hooks. Verify the ids against
  # `virsh nodedev-list --tree` (or `--cap pci`) for this machine's GPU.
  gpuPassthrough = {
    enable = true;
    vmName = "win10";
    gpuVideoId = "pci_0000_03_00_0";
    gpuAudioId = "pci_0000_03_00_1";
  };


  hardware.amdgpu.overdrive = {
    enable = true;
  };

  services.lact.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.05";
}
