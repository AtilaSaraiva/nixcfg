{
  services.gitea = {
    enable = true;
    database.type = "mysql";
    dump.enable = true;
    #settings.service.DISABLE_REGISTRATION = true;
  };
}
