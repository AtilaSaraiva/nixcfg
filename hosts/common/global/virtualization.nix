{ ... }:

{
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
      qemuRunAsRoot = true; #option has no impact 
      qemu.swtpm.enable = true;
      #quickfix run hooks manually
      #do not uncomment, doesn't work 
      #hooks.qemu = {   
      #win10 = "/etc/nixos/";
       #};
    };

    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["atila"];


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

}
