{
  pkgs,
  inputs,
  username,
  host,
  config,
  ...
}:
let
  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    ;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../config/hyprland.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".local/share/fonts" = {
    source = ../../config/fonts;
    recursive = true;
  };
  home.file.".config/starship.toml".source = ../../config/starship.toml;
  home.file.".config/ascii-neofetch".source = ../../config/ascii-neofetch;
  home.file.".base16-themes".source = ../../config/base16-themes;
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
      prin "$(color 6)  ZaneyOS $ZANEYOS_VERSION"
      info underline
      info "$(color 7)  VER" kernel
      info "$(color 2)  UP " uptime
      info "$(color 4)  PKG" packages
      info "$(color 6)  DE " de
      info "$(color 5)  TER" term
      info "$(color 3)  CPU" cpu
      info "$(color 7)  GPU" gpu
      info "$(color 5)  MEM" memory
      prin " "
      prin "$(color 1) $(color 2) $(color 3) $(color 4) $(color 5) $(color 6) $(color 7) $(color 8)"
    }
    distro_shorthand="on"
    memory_unit="gib"
    cpu_temp="C"
    separator=" $(color 4)>"
    stdout="off"
  '';
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';


  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;

  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/themechange.nix {
      inherit pkgs;
      inherit host;
      inherit username;
    })
    (import ../../scripts/theme-selector.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    gh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        lua-language-server
        gopls
        xclip
        wl-clipboard
        luajitPackages.lua-lsp
        nil
        rust-analyzer
        nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      plugins = with pkgs.vimPlugins; [
        alpha-nvim
        auto-session
        bufferline-nvim
        dressing-nvim
        indent-blankline-nvim
        nvim-treesitter.withAllGrammars
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-surround
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim
        comment-nvim
        nvim-ts-context-commentstring
        {
          plugin = dracula-nvim;
        }
        plenary-nvim
        neodev-nvim
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
        vim-tmux-navigator
      ];
      extraConfig = ''
        set noemoji
      '';
      extraLuaConfig = ''
        ${builtins.readFile ../../config/nvim/options.lua}
        ${builtins.readFile ../../config/nvim/keymaps.lua}
        ${builtins.readFile ../../config/nvim/plugins/alpha.lua}
        ${builtins.readFile ../../config/nvim/plugins/autopairs.lua}
        ${builtins.readFile ../../config/nvim/plugins/auto-session.lua}
        ${builtins.readFile ../../config/nvim/plugins/comment.lua}
        ${builtins.readFile ../../config/nvim/plugins/cmp.lua}
        ${builtins.readFile ../../config/nvim/plugins/lsp.lua}
        ${builtins.readFile ../../config/nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ../../config/nvim/plugins/telescope.lua}
        ${builtins.readFile ../../config/nvim/plugins/todo-comments.lua}
        ${builtins.readFile ../../config/nvim/plugins/treesitter.lua}
        require("ibl").setup()
        require("bufferline").setup{}
        require("lualine").setup({
          icons_enabled = true,
          theme = 'dracula',
        })
      '';
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    rofi = {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      extraConfig = {
        modi = "drun,emoji,filebrowser,run";
        show-icons = true;
        icon-theme = "Papirus";
        location = 0;
        font = "JetBrainsMono Nerd Font Mono 16";	
        drun-display-format = "{icon} {name}";
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-filebrowser = "   File ";
        display-emoji = "   Emoji ";
        hover-select = true;
        me-select-entry = "MouseSecondary";
        me-accept-entry = "MousePrimary";
        dpi = 1;
      };
      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
        "*" = {
          bg = mkLiteral "#${config.stylix.base16Scheme.base00}";
          bg-alt = mkLiteral "#${config.stylix.base16Scheme.base09}";
          foreground = mkLiteral "#${config.stylix.base16Scheme.base01}";
          selected = mkLiteral "#${config.stylix.base16Scheme.base08}";
          active = mkLiteral "#${config.stylix.base16Scheme.base0B}";
          text-selected = mkLiteral "#${config.stylix.base16Scheme.base00}";
          text-color = mkLiteral "#${config.stylix.base16Scheme.base05}";
          border-color = mkLiteral "#${config.stylix.base16Scheme.base0F}";
          urgent = mkLiteral "#${config.stylix.base16Scheme.base0E}";
        };
        "window" = { 
          width = mkLiteral "50%";
          transparency = "real";
          orientation = mkLiteral "vertical";
          cursor = mkLiteral "default";
          spacing = mkLiteral "0px";
          border = mkLiteral "2px";
          border-color = "@border-color";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@bg";
        };
        "mainbox" = {
	        padding = mkLiteral "15px";
          enabled = true;
          orientation = mkLiteral "vertical";
          children = map mkLiteral [ "inputbar" "listbox" ];
          background-color = mkLiteral "transparent";
        };
        "inputbar" = {
          enabled = true;
          padding = mkLiteral "10px 10px 200px 10px";
          margin = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          border-radius = "25px";
          orientation = mkLiteral "horizontal";
          children = map mkLiteral ["entry" "dummy" "mode-switcher" ];
          background-image = mkLiteral "url('~/Pictures/Wallpapers/zaney-wallpaper.jpg', width)";
        };
        "entry" = {
          enabled = true;
          expand = false;
          width = mkLiteral "20%";
          padding = mkLiteral "10px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
          cursor = mkLiteral "text";
          placeholder = "🖥️ Search ";
          placeholder-color = mkLiteral "inherit";
        };
        "listbox" = {
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = map mkLiteral [ "message" "listview" ];
        };
        "listview" = {
          enabled = true;
          columns = 2;
          lines = 6;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = false;
          fixed-columns = true;    
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          border = mkLiteral "0px";
        };
        "dummy" = {
          expand = true;
          background-color = mkLiteral "transparent";
        };
        "mode-switcher" = {
          enabled = true;
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
        };
        "button" = {
          width = mkLiteral "5%";
          padding = mkLiteral "12px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@text-selected";
          text-color = mkLiteral "@text-color";
          cursor = mkLiteral "pointer";
        };
        "button selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
        };
        "scrollbar" = {
          width = mkLiteral "4px";
          border = 0;
          handle-color = mkLiteral "@border-color";
          handle-width = mkLiteral "8px";
          padding = 0;
        };
        "element" = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "transparent";
          cursor = mkLiteral "pointer";
        };
        "element normal.normal" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
        "element normal.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };
        "element normal.active" =  {
          background-color = mkLiteral "@active";
          text-color = mkLiteral "@foreground";
        };
        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@text-selected";
        };
        "element selected.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@text-selected";
        };
        "element selected.active" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@text-selected";
        };
        "element alternate.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element alternate.urgent" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element alternate.active" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
        "element-icon" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "36px";
          cursor = mkLiteral "inherit";
        };
        "element-text" = {
          background-color = mkLiteral "transparent";
          font = "JetBrainsMono Nerd Font Mono 14";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "message" = {
          background-color = mkLiteral "transparent";
          border = mkLiteral "0px";
        };
        "textbox" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@bg";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "error-message" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@bg";
        };
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        neofetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        flake-rebuild = "nh os switch --hostname ${host} /home/${username}/zaneyos";
        flake-update = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
        gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        ".." = "cd ..";
        neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      };
    };
    home-manager.enable = true;
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "/home/${username}/Pictures/Wallpapers/zaney-wallpaper.jpg";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "/home/${username}/.config/face.jpg";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1; # Negative means circle
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
