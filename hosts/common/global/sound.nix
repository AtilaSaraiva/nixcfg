{ ... }:

{
  # Enable sound.
  sound.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
  };
  hardware.pulseaudio.enable = false;
}
