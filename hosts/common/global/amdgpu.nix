{ pkgs, ... }:

{
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

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
}
