{ pkgs, config, ... }:

let
  fullDeviceList = {
    "juroscomposto" = {
      addresses = [
        "tcp://100.105.182.82:22000"
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
      };
    };
  };
}
