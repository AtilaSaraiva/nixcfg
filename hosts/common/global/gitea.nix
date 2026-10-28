{
  services.gitea = {
    enable = false; # had to disable because the gitea module now requires people
                    # to set services.gitea.settings.server.ROOT_URL
    database.type = "mysql";
    dump.enable = true;
    #settings.service.DISABLE_REGISTRATION = true;
  };
}
