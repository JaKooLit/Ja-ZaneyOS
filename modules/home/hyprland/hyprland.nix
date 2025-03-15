{
  pkgs,
  username,
  ...
}: {
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    swappy
    ydotool
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
  # Place Files Inside Home Directory
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../../wallpapers;
      recursive = true;
    };
    ".face.icon".source = ./face.jpg;
    ".config/face.jpg".source = ./face.jpg;
    ".config/swappy/config".text = ''
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
    ".config/amfora/config.toml".text = ''
      [a-general]
      home = "gemini://gem.zaney.org"
      color = true
      ansi = true
      bullets = true
      show_link = false
      scrollbar = "never"
      auto_redirect = false
      http = 'brave'
      search = "gemini://gus.guru/search"
      max_width = 140
      page_max_size = 2097152  # 2 MiB
      page_max_time = 10
      highlight_code = true
      highlight_style = "dracula"
      downloads = '~/Downloads/'
      underline = true
      [auth]
      [auth.certs]
      [auth.keys]
      [commands]
      [keybindings]
      bind_bottom           = ":"
      bind_quit             = "Q"
      bind_reload           = "R"
      bind_back             = "h"
      bind_forward          = "l"
      bind_moveup           = "k"
      bind_movedown         = "j"
      bind_moveleft         = "H"
      bind_moveright        = "L"
      bind_next_tab         = "J"
      bind_prev_tab         = "K"
      bind_edit             = "o"
      bind_new_tab          = "O"
      bind_close_tab        = "q"
      bind_save             = "S"
      bind_home             = "Ctrl-h"
      bind_bookmarks        = "b"
      bind_add_bookmark     = "B"
      bind_copy_page_url    = "c"
      bind_copy_target_url  = "C"
      bind_search           = "/"
      bind_next_match       = "n"
      bind_prev_match       = "N"
      [url-handlers]
      [url-prompts]
      [cache]
      max_size = 0  # Size in bytes
      max_pages = 30 # The maximum number of pages the cache will store
      timeout = 1800 # 30 mins
      [proxies]
      [subscriptions]
      popup = true
      update_interval = 1800 # 30 mins
      workers = 3
      entries_per_page = 20
      header = true
      [theme]
      bg = "#282a36"
      tab_num = "#bd93f9"
      tab_divider = "#f8f8f2"
      bottombar_label = "#bd93f9"
      bottombar_text = "#8be9fd"
      bottombar_bg = "#44475a"
      scrollbar = "#44475a"
      hdg_1 = "#bd93f9"
      hdg_2 = "#7cafc2"
      hdg_3 = "#a16946"
      amfora_link = "#ff79c6"
      foreign_link = "#ffb86c"
      link_number = "#8be9fd"
      regular_text = "#f8f8f2"
      quote_text = "#f1fa8c"
      preformatted_text = "#ffb86c"
      list_text = "#f8f8f2"
      btn_bg = "#44475a"
      btn_text = "#f8f8f2"
      dl_choice_modal_bg = "#6272a4"
      dl_choice_modal_text = "#f8f8f2"
      dl_modal_bg = "#6272a4"
      dl_modal_text = "#f8f8f2"
      info_modal_bg = "#6272a4"
      info_modal_text = "#f8f8f2"
      error_modal_bg = "#ff5555"
      error_modal_text = "#f8f8f2"
      yesno_modal_bg = "#6272a4"
      yesno_modal_text = "#f8f8f2"
      tofu_modal_bg = "#6272a4"
      tofu_modal_text = "#f8f8f2"
      subscription_modal_bg = "#6272a4"
      subscription_modal_text = "#f8f8f2"
      input_modal_bg = "#6272a4"
      input_modal_text = "#f8f8f2"
      input_modal_field_bg = "#44475a"
      input_modal_field_text = "#f8f8f2"
      bkmk_modal_bg = "#6272a4"
      bkmk_modal_text = "#f8f8f2"
      bkmk_modal_label = "#f8f8f2"
      bkmk_modal_field_bg = "#44475a"
      bkmk_modal_field_text = "#f8f8f2"
    '';
  };
}
