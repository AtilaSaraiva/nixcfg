{ pkgs, ... }:

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
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
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

  hardware.opengl.enable = true;

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

    # Add binaries to path so that hooks can use it
  systemd.services.libvirtd = {
    path = let
             env = pkgs.buildEnv {
               name = "qemu-hook-env";
               paths = with pkgs; [
                 bash
                 libvirt
                 kmod
                 systemd
                 ripgrep
                 sd
               ];
             };
           in
           [ env ];

    preStart =
    ''
      mkdir -p /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
      mkdir -p /var/lib/libvirt/vgabios
      
      ln -sf /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/qemu /var/lib/libvirt/hooks/qemu
      ln -sf /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/kvm.conf /var/lib/libvirt/hooks/kvm.conf
      ln -sf /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/start.sh /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      ln -sf /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/stop.sh /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
      ln -sf /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/patched.rom /var/lib/libvirt/vgabios/patched.rom
      
      chmod +x /var/lib/libvirt/hooks/qemu
      chmod +x /var/lib/libvirt/hooks/kvm.conf
      chmod +x /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      chmod +x /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
    '';
  };
}
