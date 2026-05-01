{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    loadModels = [
      "qwen2.5-coder:14b"
    ];
    openFirewall = false;
    package = pkgs.ollama-cpu;
    port = 11434;
    syncModels = true;
  };

  services.open-webui = {
    enable = true;
    port = 11345;
    openFirewall = false;
  };
}
