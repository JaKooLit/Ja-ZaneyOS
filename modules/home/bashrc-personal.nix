
{pkgs, ...}: {
  home.packages = with pkgs; [bash];

  home.file."./.bashrc-personal".text = ''

  # This file allows you to define your own aliases, functions, etc
  # below are just some examples of what you can use this file for
  
    #!/usr/bin/env bash
    # Set defaults
    #
    #export EDITOR="nvim"
    #export VISUAL="nvim"
 
    #alias c="clear"
    #eval "$(zoxide init bash)"
    #eval "$(oh-my-posh init bash --config $HOME/.config/powerlevel10k_rainbow.omp.json)"

  '';
}
