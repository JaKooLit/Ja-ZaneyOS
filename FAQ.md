# ZaneyOS FAQ for v2.3 
- **Revision v1.0**  
- **Date:** 14-Mar-2025

## Why did you create ZaneyOS ?
 
Orginally, it was simply my configuration saved on a GIT repository. It was there to promote NixOS and Hyprland. Providing a stable, working configuration.  It has never been intended as a full NixOS distro.  The `ZaneyOS` was an inside joke among friends.  The intent is this can be used as a daily driver, play games via steam, and be modified to fit your needs. 

## How do I change the Timezone? 

1. In the file, `~/zaneyos/modules/core/system.nix`  
2. Edit the line:  time.timeZone = "America/New_York"; 
3. Save the file and rebuild using the `fr` alias.
   
## How do I change the monitor settings? 

 Monitor settings are in the file:  `~/zaneyos/hosts/<HOSTNAME>/variables.nix`

 Inside the quotes the syntax is "monitor=video apapter,resolution@refresh rate, auto,scale" 
 Monitor must be in all lowercase.  If you are not sure of your video devices run 
 `hyprctl monitors` at a terminal CLI.  The output will look similar to this: 

```
hyprctl monitors
Monitor HDMI-A-1 (ID 0):
	2560x1440@143.91200 at 0x0
	description: Dell Inc. DELL S3222DGM F45WJK3
	make: Dell Inc.
	model: DELL S3222DGM
	serial: F45WJK3
	active workspace: 1 (1)
	special workspace: 0 ()
	reserved: 0 52 0 0
	scale: 1.00
	transform: 0
	focused: yes
	dpmsStatus: 1
	vrr: false
	solitary: 0
	activelyTearing: false
	directScanoutTo: 0
	disabled: false
	currentFormat: XRGB8888
	mirrorOf: none
	availableModes: 2560x1440@59.95Hz 2560x1440@143.91Hz 2560x1440@120.00Hz 1920x1200@59.95Hz 1920x1080@143.86Hz 1920x1080@120.00Hz 1920x1080@119.88Hz 1920x1080@60.00Hz 1920x1080@60.00Hz 1920x1080@59.94Hz 1920x1080@50.00Hz 1600x1200@60.00Hz 1680x1050@59.88Hz 1280x1024@75.03Hz 1280x1024@60.02Hz 1440x900@59.95Hz 1280x800@59.91Hz 1152x864@75.00Hz 1280x720@120.00Hz 1280x720@119.88Hz 1280x720@60.00Hz 1280x720@59.94Hz 1280x720@50.00Hz 1024x768@75.03Hz 1024x768@60.00Hz 800x600@75.00Hz 800x600@60.32Hz 720x576@50.00Hz 720x576@50.00Hz 720x480@60.00Hz 720x480@60.00Hz 720x480@59.94Hz 720x480@59.94Hz 640x480@75.00Hz 640x480@60.00Hz 640x480@59.94Hz 640x480@59.94Hz 720x400@70.08Hz
```

Edit the `extraMonitorSettings` line.
**Examples:**
- Single Monitor: 
	    `extraMonitorSettings = "monitor=eDP-1,1920x1080@60,auto,1";`
- Multiple Monitors:
            `extraMonitorSettins = "
            monitor=eDP-1,1920x1080@60,auto,auto
            monitor=HDMI-A-1,2560x1440@75,auto,auto
            ";` 

Information on configuring monitors is available on the [Hyprland Wiki](https://wiki.hyprland.org/Configuring/Monitors/)

##  How do I add applications to ZaneyOS? 

###  There are two options. One for all hosts you have, another for a specific host.

1.  For applications to be included in all defined hosts edit the 
	`~/zaneyos/modules/core/packages.nix` file.  
        
There is a section that begins with: 
	` environment.systemPackages = with pkgs; `

Followed by a list of packages These are required for ZaneyOS. 

We suggest you add a comment at the end of the package names. Then add in your packages. 

```
    ...
    virt-viewer
    wget
    ###  My Apps ### 
    bottom
    dua
    emacs-nox
    fd
    gping
    lazygit
    lunarvim
    luarocks
    mission-center
    ncdu
    nvtopPackages.full
    oh-my-posh
    pyprland
    shellcheck
    multimarkdown
    nodejs_23
    ugrep
    zoxide
  ];
}
```

2.  For applications that will only be on specific host. 
   
You edit the `host-packages.nix` associated with that host. `~/zaneyos/hosts/<HOSTNAME>/host-packages.nix` 

The part of the file you need to edit, looks like this: 

```nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    audacity
    discord
    nodejs
    obs-studio
  ];
}
```
    
You can add additional packages, or for example change `discord` to `discord-canary` to get the beta version of Discord but only on this host. 

## I added the package names, now how do I install them ? 

- Use the `fr`,  Flake Rebuild  alias. 

If the rebuild completes successfully, a new generation with your added packages will be created. 

## How do I update the packages I've already installed? 

- Use the `fu`, Flake Update alias. This will check for updated packages, download and install them.

## I made a change to my ZaneyOS configuration, how do I activate it? 

- Use the `fr` Flake Rebuild alias. If you **created a new file** please note you will need to run a `git add .` command in the zaneyos folder. If successful, a new generation will be generated with your changes. A logout or reboot could be required depending on what you changed. 

## I have older generations I want to delete, how can I do that? 

- The `ncg` NixOS Clean Generations alias will remove **ALL** but the most current generation. Make sure you have booted from that generation before using this alias. There is also a schedule that will remove older generations automatically over time. 

## How do I change the hostname?  

To change the hostname, there are several steps and you will have to reboot to make the change effective. 

1. Copy the directory of the host you want to rename to a directory with the new name. 

- `cp -rpv ~/zaneyos/hosts/OLD-HOSTNAME ~/zaneyos/hosts/NEW-HOSTNAME `

2. Edit the `~/zaneyos/flake.nix` file. Change the line:

- `host = "NEW-HOSTNAME"`  
    
3.  In the `~/zaneyos` Directory run `git add .` *The rebuild will fail with a 'file not found' error if you forget this step.*

4.  Use the `fr` alias to create a new generation with the new hostname.  You must reboot to make the change effective. 

## How do I update my version ZaneyOS ? 

###  For versions v2.3+ 

1. First backup your existing  `zaneyos` directory.

- `cp -rpv ~/zaneyos ~/Backup-ZaneyOS`

*Any changes you made to the ZaneyOS config will need to be re-done*

2. In the `zaneyos` directory run `git stash && git pull` 

3. Copy back your previously created host(s). 

- `cp -rpv ~/Backup-ZaneyOS/hosts/HOSTNAME  ~/zaneyos/hosts `

4. If you did not use the `default` host during your initial install

- Then  do not copy the `default` host from your backup. The new default host might have updates or fixes you will need for the next host you create.**
- Then you will have to manually compare your backup to the new updated `default` host template, and potentially merge the changes and overwrite your `hardware.nix` file to the `~/zaneyos/hosts/default/hardware.nix` file.**

5. In the `zaneyos` directory run `git add .` when you have finished copying your host(s).  

6. For any other changes you've made. For example: hyprland keybinds, waybar config, if you added additional packages to the `modules/packages.nix` file.  Those you will have to manually merge back into the new version. 

### For versions v2.0->2.2

1. First backup your existing  `zaneyos` directory.  e.g. `cp -r ~/zaneyos ~/zaneyos-backup`
 
2. There is no direct update. When you clone the the new config the config files and layout have changed.

3. You need to install zaneyos like a new install.  `./install-zaneyos.sh`

4. Once the build completes and you have rebooted you can review the new layout and decide what if any changes you made on the earlier version can be migrated to v2.3.

### For version v1.x 

1. The layout and configuration are completely different. Virtually noting from 1.x is applicable to v2.3.

2. Backup your `zaneyos` directory e.g. `cp -r ~/zaneyos ~/zaneyos-backup`

3. Run the `./install-zaneyos.sh` script and follow the new install instructions. 

## How do I know when a new version of ZaneyOS is released? 

It will be announced on the Zaney [Discord](https://discord.gg/W7efsSDS) server.

## How do I configure my hybrid laptop with Intel/NVIDIA GPUs? 

1. Either run the `install-zaneyos.sh` script and select `nvidia-laptop` template or if configuring manually, set the template in the `flake.nix` to `nvidia-prime`  

2. In the `~/zaneyos/hosts/HYBRID-HOST/variables.nix` file you will need to set the PCI IDs for the Intel and NVIDIA GPUs. Refer to [this page](https://nixos.wiki/wiki/Nvidia) to help determine those values.

3. Once you have everything configured properly, use the `fr` Flake Rebuild alias to create a new generation. 

4. In the `~/zaneyos/modules/home/hyprland/config.nix` file is an ENV setting` "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"` This sets the primary and secondary GPUs. Using the info from the weblink above you might have to change the order of these values.

## What are the Kitty keybindings and how can I change them? 

The kitty bindings are configured in `~/zaneyos/modules/home/kitty.nix`  
  
The defaults are:

```
    # Clipboard
    map ctrl+shift+v        paste_from_selection
    map shift+insert        paste_from_selection

    # Scrolling
    map ctrl+shift+up        scroll_line_up
    map ctrl+shift+down      scroll_line_down
    map ctrl+shift+k         scroll_line_up
    map ctrl+shift+j         scroll_line_down
    map ctrl+shift+page_up   scroll_page_up
    map ctrl+shift+page_down scroll_page_down
    map ctrl+shift+home      scroll_home
    map ctrl+shift+end       scroll_end
    map ctrl+shift+h         show_scrollback

    # Window management
    map alt+n               new_os_window
    map alt+w               close_window
    map ctrl+shift+enter    launch --location=hsplit
    map ctrl+shift+s        launch --location=vsplit
    map ctrl+shift+]        next_window
    map ctrl+shift+[        previous_window
    map ctrl+shift+f        move_window_forward
    map ctrl+shift+b        move_window_backward
    map ctrl+shift+`        move_window_to_top
    map ctrl+shift+1        first_window
    map ctrl+shift+2        second_window
    map ctrl+shift+3        third_window
    map ctrl+shift+4        fourth_window
    map ctrl+shift+5        fifth_window
    map ctrl+shift+6        sixth_window
    map ctrl+shift+7        seventh_window
    map ctrl+shift+8        eighth_window
    map ctrl+shift+9        ninth_window
    map ctrl+shift+0        tenth_window

    # Tab management
    map ctrl+shift+right    next_tab
    map ctrl+shift+left     previous_tab
    map ctrl+shift+t        new_tab
    map ctrl+shift+q        close_tab
    map ctrl+shift+l        next_layout
    map ctrl+shift+.        move_tab_forward
    map ctrl+shift+,        move_tab_backward

    # Miscellaneous
    map ctrl+shift+up      increase_font_size
    map ctrl+shift+down    decrease_font_size
    map ctrl+shift+backspace restore_font_size

```

## What are the Yazi keybindings and how can I change them? 

The Yazi configuration file is located in `~/zaneyos/modules/home/yazi.nix`

Yazi is configured like VIM and VIM motions 

The keymap is in the `~/zaneyos/modules/home/yazi/keymap.toml` file

## How do I enable WezTerm? 

 Edit the `/zaneyos/modules/home/wezterm.nix`  Change `enable = false` to `enable = true;`  
 Save the file and rebuild zaneyos with the `fr` command. 

```
{pkgs, ...}: {
  programs.wezterm = {
    enable = false;
    package = pkgs.wezterm;
  };

``` 
## What are the WezTerm keybindings and how can I change them? 

The kitty bindings are configured in `~/zaneyos/modules/home/wezterm.nix`  
  
The defaults are:
```
ALT is the defined META key for WezTerm
  -- Tab management
ALT + t                 Open new Tab
ALT + w                 Close current Tab
ALT + n                 Move to next Tab
ALT + p                 Move to previous Tab 
  -- Pane management
ALT + v                 Create Vertical Split
ALT + h                 Create Horizontal Split
ALT + q                 Close Current Pane
   -- Pane navigation (move between panes with ALT + Arrows)
ALT + Left Arrow        Move to pane -- Left
ALT + Right Arrow       Move to pane -- Right
ALT + Down Arrow        Move to pane -- Down
ALT + Up Arrow          Move to pane -- Down

```

## I am new to NIXOS where can I go to get more info? 

- [NIXOS Config Guide](https://www.youtube.com/watch?v=AGVXJ-TIv3Y&t=34s)
- [VIMJOYER YouTube Channel](https://www.youtube.com/@vimjoyer/videos)
- [Librephoenix YouTube Channel](https://www.youtube.com/@librephoenix)
- [8 Part Video Series on NIXOS](https://www.youtube.com/watch?v=QKoQ1gKJY5A&list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-)

## Where can I get info on using GIT repositories 

- [Managing NIXOS config with GIT](https://www.youtube.com/watch?v=20BN4gqHwaQ)
- [GIT for dummies](https://www.youtube.com/watch?v=K6Q31YkorUE)
- [How GIT works](https://www.youtube.com/watch?v=e9lnsKot_SQ)
- [In depth 1hr video on GIT](https://www.youtube.com/watch?v=S7XpTAnSDL4&t=123s)
