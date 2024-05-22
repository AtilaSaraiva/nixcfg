{ lib, config, ... }:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      main = {
        blocks = [
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 60;
          }
          {
            block = "battery";
            device = "BAT1";
            format = " $icon $percentage $time $power ";
          }
          {
            block = "sound";
          }
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "net";
            format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
            interval = 2;
            theme_overrides = {
              idle_bg = "#00223f";
            };
          }
        ];
        theme = "space-villain";
        icons = "awesome5";
      };
    };
  };
}
