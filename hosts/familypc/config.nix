{
  config,
  pkgs,
  host,
  inputs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) browser;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
  boot.tmp.useTmpfs = false;
  boot.tmp.tmpfsSize = "30%";
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # This is for OBS Virtual Cam Support - v4l2loopback setup
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  networking.hostName = "${host}";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    firefox.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };

  # Steam Configuration
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    cmatrix
    lolcat
    neofetch
    htop
    btop
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    eza
    v4l-utils
    ydotool
    wl-clipboard
    socat
    cowsay
    lsd
    lshw
    pkg-config
    meson
    gnumake
    ninja
    symbola
    noto-fonts-color-emoji
    material-icons
    brightnessctl
    virt-viewer
    swappy
    ripgrep
    appimage-run
    networkmanagerapplet
    yad
    playerctl
    nh
    nixfmt-rfc-style
    discord
    libvirt
    swww
    grim
    slurp
    gnome.file-roller
    swaynotificationcenter
    rofi-wayland
    imv
    transmission-gtk
    mpv
    gimp
    obs-studio
    rustup
    audacity
    pavucontrol
    tree
    protonup-qt
    font-awesome
    spotify
    neovide
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.variables = {
    ZANEYOS_VERSION = "2.0";
  };

  # Services to start
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.libinput.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Security / Polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  virtualisation.libvirtd.enable = true;

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
