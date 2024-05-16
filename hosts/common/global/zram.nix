{ lib, ... }:

{
  zramSwap = {
    enable = true;
    priority = 32000;
    algorithm = "lz4";
    memoryPercent = lib.mkDefault 10;
  };
}
