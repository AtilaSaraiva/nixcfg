{ pkgs, ... }:

{
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjk1uFc3D20HmWW3Yn0bupdugufeNi0xDfS0zHjqeQ2 atilasaraiva@gmail.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2UVYlqXlbOYVEI4iYBuXbACB5nctyNdC/MS9Zt5zNt atilasaraiva@gmail.com"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "docker" "audio" "networkmanager"];
    };
  };
}
