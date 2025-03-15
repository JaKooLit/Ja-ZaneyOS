{pkgs, ...}: {
  home.packages = with pkgs; [zsh];

  home.file."./.zshrc-personal".text = ''

  # This file allows you to define your own aliases, functions, etc
  # below are just some examples of what you can use this file for
  
    #!/usr/bin/env zsh
    # Set defaults
    #
    #export EDITOR="nvim"
    #export VISUAL="nvim"
 
    #alias c="clear"
    #eval "$(zoxide init zsh)"
    #eval "$(oh-my-posh init zsh --config $HOME/.config/powerlevel10k_rainbow.omp.json)"

  '';
}

