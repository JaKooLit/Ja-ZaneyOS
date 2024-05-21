<div align="center">

## ZaneyOS 🟰 Best ❄️ NixOS Configs

ZaneyOS is a simple way of reproducing my configuration on any NixOS system. This includes the wallpaper, scripts, applications, config files, and more.

<img align="center" width="80%" src="https://gitlab.com/Zaney/zaneyos/-/raw/main/config/demo.png" />    

**Inspiration for the Waybar config [here](https://github.com/justinlime/dotfiles).**

</div>

> **This project has a [Wiki](https://zaney.org/zaneyos-2.0/). Find out how to use ZaneyOS here!**
> **I have put a lot of effort into the [documentation](https://zaney.org/zaneyos-2.0/) so it should be accurate. However, please if you notice that something is wrong with it create an issue or reach out to me on Discord.**

#### 🍖 Requirements
- You must be running on NixOS.
- The zaneyos folder (this repo) is expected to be in your home directory.
- Must have installed using GPT & UEFI. Systemd-boot is what is supported, for GRUB you will have to brave the internet for a how-to. ☺️
- Manually editing your host specific files. The host is the specific computer your installing on.

#### 🎹 Pipewire, Spotify, & Notification Menu Controls
- We are using the latest and greatest audio solution for Linux. If you like listening to music Spotify comes pre-installed out of the box. Not to mention you will have media and volume controls in the notification center available in the top bar.

#### 🏇 Optimized Workflow, tmpfs For Speed, & Simple Yet Elegant Neovim
- Using scratchpads with Hyprland for increased functionality and effeciency.
- A tmpfs for the /tmp directory is created improving rebuild time and reducing strain on hdd/ssd.
- No massive Neovim project here. This is my simple, easy to understand, yet incredible Neovim setup. You can grep recursively through entire folders and find specific files without ever leaving the text editor!

#### 🖥️ Multi Host & User Configuration
- You can now define separate settings for different host machines and users!
- Easily specify extra packages for your users in the users.nix file.
- Easy to understand file structure and simple, but encompassing, configuratiion.

#### 👼 An Incredible Community Focused On Support
- The entire idea of ZaneyOS is to make NixOS an approachable space that is actually a great community that you want to be in.
- Many people who are patient and happy to spend their free time helping you are running ZaneyOS. Feel free to reach out on the Discord for any help with anything.

<div align="center">

Please do yourself a favor and [read the wiki](https://zaney.org/zaneyos-2.0/).

</div>

#### 📦 How To Install Packages?
- You can search the [Nix Packages](https://search.nixos.org/packages?) & [Options](https://search.nixos.org/options?) pages for what a package may be named or if it has options available that take care of configuration hurdles you may face.
- To add a package there are the sections for it in config.nix and users.nix in your host folder. One is for programs available system wide and the other for your users environment only.

#### 🙋 Having Issues / Questions?
- Please feel free to raise an issue on the repo, please label a feature request with the title beginning with [feature request], thank you!
- Contact me on [Discord](https://discord.gg/2cRdBs8) as well, for a potentially faster response.

### Changelog

**ZaneyOS 2.0**

With this new update of ZaneyOS it is a big rewrite of how things are being done. This update fixes many issues that you guys were facing. As well as makes things a little easier to understand. You now have a lot being stored inside the specific host directory, making use of modules, condensing seperate files down, etc. 
My hope is that with this update your ability to grasp the flake and expand it to what you need is much improved. I want to thank everyone for being so supportive!

- Most configuration put into specific hosts directories for the best portability.
- Using modules to condense configuration complexity.
- Simplified options and the complexity around understanding their implementation.
- Rewrote the documentation for improved readability.

**ZaneyOS 2.1**

Simple bug fixes.

- Fixed Waybar icons to make them look a bit better.
- Centered the Wofi window always.
- Should have fixed some Steam issues, but I have had some crashes due to Steam so be aware of that.
- The flake got an update, so all the packages are fresh.

### ⬇️ Install

#### 📜 Script:

This is the easiest and recommended way of starting out. The script is not meant to allow you to change every option that you can in the flake or help you install extra packages. It is simply here so you can get my configuration installed with as little chances of breakages and then fiddle to your hearts content!

Simply copy this and run it:

```
nix-shell -p git curl
sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)
```

#### 🦽 Manual:

Run this command to ensure Git & Vim are installed:

```
nix-shell -p git vim
```

Clone this repo & enter it:

```
git clone https://gitlab.com/zaney/zaneyos.git
cd zaneyos
```

- *You should stay in this folder for the rest of the install*

Create the host folder for your machine(s)

```
cp -r hosts/default hosts/<your-desired-hostname>
```

**🪧🪧🪧 Edit options.nix 🪧🪧🪧**

Generate your hardware.nix like so:

```
nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix
```

Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:

```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```

Now when you want to rebuild the configuration you have access to an alias called flake-rebuild that will rebuild the flake!

Hope you enjoy!
