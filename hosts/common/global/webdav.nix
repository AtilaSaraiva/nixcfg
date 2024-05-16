{
  services.webdav = {
    enable = true;
    user = "atila";
    settings = {
      address = "0.0.0.0";
      port = 31460;
      scope = "/home/atila/Files/zotero/";
      modify = true;
      auth = true;
      users = [
        {
          username = "atila";
          password = "qwerty";
        }
      ];
    };
  };
}
