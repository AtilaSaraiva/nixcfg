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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    package = pkgs.nix;
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      trusted-public-keys = [
        "key-name:36fe2VUzGDWhD3851hppXbCgQqlMtKSL7XPGNYnzAZk="
      ];
    };

    # Opinionated: make flake registry and nix path match nix run ripgrep#nixpkgs defaultUserShellflake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration
  #services.xserver.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # I need this to configure sway from home-manager in the future
  security.polkit.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock-effects
      xwayland
      swayidle
      swaytools
      killall
      oguri
      wf-recorder
      wl-clipboard
      sway-contrib.grimshot
      mako # notification daemon
      kitty # Alacritty is the default terminal in the config
      waybar
      autotiling
      wlsunset
      cinnamon.nemo
      jq
      playerctl
      wev
      sirula
      lxappearance
      adapta-gtk-theme
      gnome.adwaita-icon-theme
      wdisplays
      rofi
    ];
    extraSessionCommands = ''
      #export SDL_VIDEODRIVER=wayland
      #export QT_QPA_PLATFORM=wayland
      #export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    firewall = {
      enable = false;
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
    };
    resolvconf.enable = true;
    useDHCP = false;
  };

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

  services.tailscale.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  services.printing = {
    enable = true;
    startWhenNeeded = false;
    browsing = false;
    drivers = [ ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;
  hardware.printers = {
    ensurePrinters = [
      {
        name = "BrotherDCPL2550DW";
        location = "Home";
        deviceUri = "ipp://10.0.0.132:631/ipp";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
          PrintQuality="4";
          PwgRasterDocumentType="SGray_8";
        };
      }
    ];
    ensureDefaultPrinter = "BrotherDCPL2550DW";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

      hardware.sane = {
      enable = true;
      brscan5 = {
        enable = true;
        netDevices = {
          brother = {
            ip = "10.0.0.132";
            model = "DCP-L2550DW";
          };
        };
      };
      extraBackends = [ pkgs.sane-airscan ];
    };

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
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };

    hardware.opengl.extraPackages = with pkgs; [ # TODO: create an option for amdgpus
      rocm-opencl-icd
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];

    hardware.opengl.extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
      pkgs.driversi686Linux.mesa
    ];




  # TODO: Set your hostname
  networking.hostName = "igris";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    atila = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correct,horse,battery,staple";
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1001;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEDBtZRp53vGMrfJpuy9DZDgN1B77zB141EQG++PHD6 atilasaraiva@gmail.com"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "docker" "audio" "networkmanager"];
    };
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
    };
  };

  services.logind.lidSwitch = "suspend";

  systemd.oomd.enable = true;

  services.udisks2.enable = true;

  programs.noisetorch.enable = true;

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  i18n.defaultLocale = "pt_BR.UTF-8";

  time.timeZone = "America/Edmonton";

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/home/atila/.ssh/cache-priv-key.pem";
  };

  services.flatpak.enable = true;



  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.05";
}
