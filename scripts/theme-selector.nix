{ pkgs }:

pkgs.writeShellScriptBin "theme-selector" ''
  # Get user selection for new theme from base16-themes file
  chosen=$(cat $HOME/.base16-themes | ${pkgs.rofi-wayland}/bin/rofi -i -dmenu)
  
  # Exit if none chosen.
  [ -z "$chosen" ] && exit

  ${pkgs.libnotify}/bin/notify-send "$chosen is building please wait" &
  themechange "$chosen"
''
