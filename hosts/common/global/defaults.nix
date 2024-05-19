{ inputs, outputs, pkgs, lib, ... }:

{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts = {
    packages = with pkgs; [
     font-awesome
     cantarell-fonts
     roboto-mono
     fantasque-sans-mono
     material-icons
    ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };

  systemd.oomd.enable = true;

  services.udisks2.enable = true;

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  security.pam.loginLimits = [
    { domain = "*"; item = "memlock"; type = "hard"; value = "unlimited"; }
    { domain = "*"; item = "memlock"; type = "soft"; value = "unlimited"; }
  ];

  boot.kernel.sysctl = {
    "abi.vsyscall32" = 0;
    "vm.swappiness"  = 7;
    "kernel.sysrq"   = 1;
  };

  services.upower.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
