{ pkgs, inputs, ... }:

{
  hardware.graphics.extraPackages = with pkgs; [ # TODO: create an option for amdgpus
    #rocm-opencl-icd
    #amdvlk
    libva-vdpau-driver
    libvdpau-va-gl
    libva
  ];

  hardware.graphics.extraPackages32 = [
    #pkgs.driversi686Linux.amdvlk
    pkgs.driversi686Linux.mesa
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    radeontop
  ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
}
