{
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    accounts.default = {
      auth = true;
      host = "smtp.gmail.com";
      passwordeval = "cat /secrets/password.txt";
      port = 587;
      tls = true;
      user = "atilasaraiva@gmail.com";
      from = "juroscomposto@mycomputers.com";
    };
  };

  services.mail.sendmailSetuidWrapper = true;
}
