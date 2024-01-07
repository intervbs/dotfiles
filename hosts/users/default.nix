{
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "legion";
   services = {
    dbus.enable = true;
    xserver = {
      videoDrivers = ["amdgpu"];
      displayManager = {
        sessionCommands = ''
          ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI-1 --mode 2560x1440 --pos 2560x0 --rotate normal --output eDP-2 --mode 1920x1080 --pos 5120x360 --rotate normal
        '';
      };
    };
  };
}