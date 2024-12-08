{ config, pkgs, lib, ... }:

{
  imports = [
    ./zshmarks.nix
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      n = "nvim .";
      sl = "exa";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";
      ip = "ip --color=auto";
      ma = "mani run";
      cleanBranches = "git branch --merged | grep -v \* | xargs git branch -D";
      julia = "LD_LIBRARY_PATH=/run/opengl-driver/lib/ julia";
      jl = "LD_LIBRARY_PATH=/run/opengl-driver/lib/ julia --project -t auto";
      v = "${pkgs.fzf}/bin/fzf --bind 'enter:become(nvim {})'";
      cf = "cd $(find . -type d | fzf)";
      top = "cd $(git rev-parse --show-toplevel)";
      j = "jump";
      nixGL = "nix run --impure github:nix-community/nixGL -- ";
      pj = "cd $(${pkgs.fzf}/bin/fzf --walker=dir,hidden --walker-root=$HOME/${config.folders.projects})";
    };

    history = {
      save = 10000000;
      size = 10000000;
      share = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "colored-man-pages"
        "compleat"
        "tmux"
      ];
      theme = lib.mkDefault "gnzh";
    };

    plugins = with pkgs; [
      {
        name = "zshmarks";
        src = fetchFromGitHub {
          owner = "jocelynmallon";
          repo = "zshmarks";
          rev = "a766c6bc81f0412152499e83c818244b2eed1a77";
          sha256 = "16z9jjiy3kfw0i9xh4jdhnwy04z807nr7qfq98vzzc43dw2qblml";
        };
        file = "zshmarks.plugin.zsh";
      }
      {
        name = "zsh-autopair";
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
          sha256 = "0q9wg8jlhlz2xn08rdml6fljglqd1a2gbdp063c8b8ay24zz2w9x";
        };
        file = "zsh-autopair.plugin.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initExtraFirst = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      zvm_after_init_commands+=('eval "$(${pkgs.fzf}/bin/fzf --zsh)"')
    '';

      #zvm_after_init_commands+=('[ -f ~/ ] && source ~/.fzf.zsh')
    initExtra = ''
      bindkey '^ ' autosuggest-accept
    '';

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  home.packages = with pkgs; [
    eza
    vl
    cl
    vg
    rgf
    rgff
  ];
}
