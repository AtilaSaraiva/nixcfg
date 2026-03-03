{
  home.file = {
    ".ssh/config".source = ./config;
    ".ssh/multi/README.md".text = ''
      This folder is meant for openssh to be able
      to reuse ssh connections in future ssh logins.
    '';
  };
}
