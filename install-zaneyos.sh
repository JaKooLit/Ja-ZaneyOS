#!/usr/bin/env bash

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "This is not NixOS or the distribution information is not available."
  exit
fi

if command -v git &> /dev/null; then
  echo "Git is installed, continuing with installation."
  echo "-----"
else
  echo "Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "Default options are in brackets []"
echo "Just press enter to select the default"
sleep 2

echo "-----"

echo "Ensure In Home Directory"
cd || exit

echo "-----"

read -rp "Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "zaneyos" ]; then
  echo "ZaneyOS exists, backing up to .config/zaneyos-backups folder."
  if [ -d ".config/zaneyos-backups" ]; then
    echo "Moving current version of ZaneyOS to backups folder."
    mv "$HOME"/zaneyos .config/zaneyos-backups/"$backupname"
    sleep 1
  else
    echo "Creating the backups folder & moving ZaneyOS to it."
    mkdir -p .config/zaneyos-backups
    mv "$HOME"/zaneyos .config/zaneyos-backups/"$backupname"
    sleep 1
  fi
else
  echo "Thank you for choosing ZaneyOS."
  echo "I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering ZaneyOS Repository"
git clone https://gitlab.com/zaney/zaneyos.git
cd zaneyos || exit
mkdir hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
git add .
sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix

echo "-----"

installusername=$("$USER")
sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings & Committing Changes"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

echo "ZaneyOS Has Been Setup"
echo "Please Edit Your Hosts Files"
echo "Then Run: sudo nixos-rebuild switch --flake .#${hostName}"
