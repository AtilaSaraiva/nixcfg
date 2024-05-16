{ lib, ... }:

{
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.tmpfsSize = lib.mkDefault "400%";
}
