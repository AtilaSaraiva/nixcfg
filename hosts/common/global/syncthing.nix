{ pkgs, config, ... }:

let
  fullDeviceList = {
    "juroscomposto" = {
      addresses = [
        "tcp://100.109.26.105:22000"
        "tcp://juroscomposto:22000"
      ];
      id = "FDQLIPX-66WWRBQ-JDVUEA3-BDPNIRD-LSEAZYM-ED6COS6-SOJ3WVC-AR724AM";
    };
    "igris" = {
      addresses = [
        "tcp://100.122.44.105:22000"
        "tcp://igris:22000"
      ];
      id = "MXHKQWK-EP2WM3O-SDFREV5-EJGTLS4-B32GTUH-S44E5QW-C4MGSEE-G5HCJQU";
    };
    "betinha" = {
      addresses = [
        "tcp://100.85.111.84:22000"
        "tcp://betinha:22000"
      ];
      id = "FV4WQTI-UEJRULE-YCGUBOC-7RZ6GCH-F2PGCNS-GLNQ3H6-JOPU6WL-VKS5LQQ";
    };
    "s20" = {
      addresses = [
        "tcp://100.84.238.106:22000"
        "tcp://s20:22000"
      ];
      id = "7C4YYLU-Y66UB7N-FBHLYIH-WQOGZFW-OER2CRH-5G64AC4-JUE7C7K-GILI6AR";
    };
  };

  removeHost = attrset: builtins.removeAttrs attrset [ config.networking.hostName ];
in
{
  services.syncthing = {
    enable = true;
    user = "atila";
    dataDir = "/home/atila/Files/synced";    # Default folder for new synced folders
    configDir = "/home/atila/.config/syncthing";   # Folder for Syncthing's settings and keys
    guiAddress = "0.0.0.0:8384";
    settings = {
      overrideDevices = true;
      overrideFolders = true;
      devices = removeHost fullDeviceList;
      folders = {
        "main" = {
          path = "/home/atila/Files/synced";
          devices = builtins.attrNames (removeHost fullDeviceList);
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
        "Photos" = {
          id = "z4oq6-8bcvu";
          path = "/home/atila/Files/Imagens/Photos";
          devices = builtins.attrNames (removeHost fullDeviceList);
        };
        "Camera" = {
          id = "sm-g781b_uygd-photos";
          path = "/home/atila/Files/Imagens/Camera";
          devices = builtins.attrNames (removeHost fullDeviceList);
        };
      };
    };
  };
}
