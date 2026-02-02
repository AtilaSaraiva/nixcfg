{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "AtilaSaraiva";
        email = "atilasaraiva@gmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        df = "diff";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lga = "log --graph --decorate --oneline --abbrev-commit --all";
        lgb = "log --graph --decorate --oneline --abbrev-commit --all --date=relative --name-status";
        cia = "commit --amend";
      };
      extraConfig = {
        core = {
          askpass = "";
        };
        protocol.version = 2;
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
    ];
  };
  programs.gh-dash = {
    enable = true;
  };
}
