{pkgs, ...}: {
  programs.fastfetch = {
    enable = true;
    
    logo = {
        source = ./nixos.png;
        type = "kitty-direct";
        height = 15;
        width = 30;
        padding = {
            top = 3;
            left = 3;
        };
    };
    modules = [
        "break"
        {
            type = "custom";
            format = "\u001b[90m┌──────────────────────Hardware──────────────────────┐";
        }
        {
            type = "cpu";
            key = "│ ";
            keyColor = "35";
        }
        {
            type = "gpu";
            key = "│ 󰍛";
            keyColor = "35";
        }
        {
            type = "memory";
            key = "│ 󰑭";
            keyColor = "35";
        }
        {
            type = "custom";
            format = "\u001b[90m└────────────────────────────────────────────────────┘";
        }
        "break"
        {
            type = "custom";
            format = "\u001b[90m┌──────────────────────Software──────────────────────┐";
        }
        {
            type = "custom";
            format = "\u001b[31m OS -> ZaneyOS 2.2";
        }
        {
            type = "kernel";
            key = "│ ├";
            keyColor = "31";
        }
        {
            type = "packages";
            key = "│ ├󰏖";
            keyColor = "31";
        }
        {
            type = "shell";
            key = "└ └";
            keyColor = "31";
        }
        "break"
        {
            type = "wm";
            key = " WM";
            keyColor = "32";
        }
        {
            type = "wmtheme";
            key = "│ ├󰉼";
            keyColor = "32";
        }
        {
            type = "terminal";
            key = "└ └";
            keyColor = "32";
        }
        {
            type = "custom";
            format = "\u001b[90m└────────────────────────────────────────────────────┘";
        }
        "break"
        {
            type = "custom";
            format = "\u001b[90m┌────────────────────Uptime / Age────────────────────┐";
        }
        {
            type = "command";
            key = "│ ";
            keyColor = "33";
            text = pkgs.writeShellScriptBin "fs-bday" # bash
            ''
              birth_install=$(stat -c %W /)
              current=$(date +%s)
              delta=$((current - birth_install))
              delta_days=$((delta / 86400))
              echo $delta_days days
            '';
        }
        {
            type = "uptime";
            key = "│ ";
            keyColor = "33";
        }
        {
            type = "custom";
            format = "\u001b[90m└────────────────────────────────────────────────────┘";
        }
        "break"
    ];
  };
}
