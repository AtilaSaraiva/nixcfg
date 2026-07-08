{ pkgs, lib, config, ... }:

let
  cfg = config.gpuPassthrough;

  # Binaries the hook scripts need on their PATH.
  hookPath = lib.makeBinPath (with pkgs; [
    bash
    coreutils   # tee, sleep, echo
    libvirt     # virsh
    kmod        # modprobe
    procps      # pkill
    systemd     # systemctl
  ]);

  # Bake the PCI ids, target VM name and binary paths into each hook script and
  # copy the result to the nix store. libvirt runs every file it finds in
  # /var/lib/libvirt/hooks/qemu.d/ for every qemu event; each script filters on
  # the arguments libvirt passes (see start.sh / stop.sh). replaceVarsWith errors
  # on tokens it can't find, so each script only gets the ones it actually uses.
  # isExecutable is required: libvirt silently ignores non-executable hook files,
  # and replaceVars/substitute produce 0444 output by default.
  commonVars = {
    binPath  = hookPath;
    vmName   = cfg.vmName;
    gpuVideo = cfg.gpuVideoId;
    gpuAudio = cfg.gpuAudioId;
  };
in
{
  options.gpuPassthrough = {
    enable = lib.mkEnableOption "single-GPU passthrough libvirt hooks for an AMD GPU";

    vmName = lib.mkOption {
      type = lib.types.str;
      default = "win10";
      description = "Name of the libvirt guest the passthrough hooks act on.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "atila";
      description = "User whose sway session owns the GPU and must be killed to release it.";
    };

    gpuVideoId = lib.mkOption {
      type = lib.types.str;
      example = "pci_0000_03_00_0";
      description = ''
        virsh nodedev name of the GPU video function (as printed by
        `virsh nodedev-list --tree` / `virsh nodedev-list --cap pci`).
      '';
    };

    gpuAudioId = lib.mkOption {
      type = lib.types.str;
      example = "pci_0000_03_00_1";
      description = "virsh nodedev name of the GPU audio function.";
    };
  };

  config = {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };

        # Single-GPU passthrough hooks. libvirt copies these store paths into
        # /var/lib/libvirt/hooks/qemu.d/ and runs them for every qemu event; the
        # scripts self-filter on the guest name and event.
        hooks.qemu = lib.mkIf cfg.enable {
          gpu-passthrough-start = pkgs.replaceVarsWith {
            src = ./start.sh;
            replacements = commonVars // { user = cfg.user; };
            isExecutable = true;
          };
          gpu-passthrough-stop = pkgs.replaceVarsWith {
            src = ./stop.sh;
            replacements = commonVars;
            isExecutable = true;
          };
        };
      };

      spiceUSBRedirection.enable = true;
    };
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = ["atila"];

    hardware.graphics.enable = true;

     #Enables VM connection
    programs.dconf.profiles.user.databases = [
      { lockAll = true;

        settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };
      }
    ];
  };
}
