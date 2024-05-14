{
  userHome = "/home/${setUsername}";
  flakeDir = "/home/${setUsername}/zaneyos";
  wallpaperDir = "/home/${setUsername}/Pictures/Wallpapers";
  screenshotDir = "/home/${setUsername}/Pictures/Screenshots";
  flakePrev = "/home/${setUsername}/.zaneyos-previous";
  flakeBackup = "/home/${setUsername}/.zaneyos-backup";

  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Tyler Kelley";
  gitEmail = "tylerzanekelley@gmail.com";

  # Base16 Theme
  theme = "atelier-cave";

  # Hyprland Settings
  borderAnim = true; # Enable / Disable Hyprland Border Animation
  extraMonitorSettings = "";

  # Program Options
  browser = "firefox"; # Set Default Browser
  terminal = "kitty";  # Set Default System Terminal
}

