{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/home/atila/.ssh/cache-priv-key.pem";
  };
}
