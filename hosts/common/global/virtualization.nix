{ ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    virtualbox = {
      guest.enable = true;
      host = {
        enable = true;
        enableKvm = true;
      };
    };
  };
}
