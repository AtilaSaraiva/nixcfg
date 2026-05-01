{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    loadModels = [
      "qwen3.6:27b-coding-mxfp8"
    ];
    openFirewall = false;
    package = pkgs.ollama-cpu;
    port = 11434;
    syncModels = true;
  };

  services.open-webui.enable = true;
}
