{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    loadModels = [
      "qwen2.5-coder:14b"
      "devstral-small-2"
      "qwen3.6:35b"
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
