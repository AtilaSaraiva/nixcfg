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
    graphics = {
      enable = true;
    };
  };

  services.dbus.enable = true;

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
    enableDefaultPackages = true; # Those fonts you expect every distro to have.
    packages = with pkgs; [
      borg-sans-mono
      cantarell-fonts
      fira
      fira-code
      fira-code-symbols
      font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk-sans
      open-fonts
      roboto
      ubuntu_font_family
    ];
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Fira Code" ];
      };
    };
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
    # giving realtime priority for any program ran by users
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  boot.kernel.sysctl = {
    "abi.vsyscall32" = 0;
    "vm.swappiness"  = 3;
    "kernel.sysrq"   = 1;
    "vm.vfs_cache_pressure" = 50;
  };

  systemd.coredump.enable = false;

  system.autoUpgrade = {
    enable = lib.mkDefault true;
    flake = "github:AtilaSaraiva/nixcfg";
    persistent = true;
    operation = lib.mkDefault "boot";
    dates = lib.mkDefault "daily";
  };

  services.upower.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  services.fwupd.enable = true;
}
