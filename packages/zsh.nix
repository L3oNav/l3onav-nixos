{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    sessionVariables = {
      ZSH_CACHE_DIR = "${config.xdg.cacheHome}/oh-my-zsh";
    };

    envExtra = ''
      # Ensure ZSH cache dir exists before plugins load
      [[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
    '';

    plugins = with pkgs; [
      {
        name = "zsh-completions";
        src = zsh-completions;
      }
      {
        name = "nix-zsh-completions";
        src = nix-zsh-completions;
      }
      {
        name = "you-should-use";
        src = zsh-you-should-use;
      }
      {
        name = "zsh-nix-shell";
        src = zsh-nix-shell;
      }
      {
        name = "1password";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/1password";
      }
      {
        name = "autoenv";
        src = zsh-autoenv;
      }
      {
        name = "celery";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/celery";
      }
      {
        name = "command-not-found";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/command-not-found";
      }
      {
        name = "direnv";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/direnv";
      }
      {
        name = "extract";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/extract";
      }
      {
        name = "fzf";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/fzf";
      }
      {
        name = "gh";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/gh";
      }
      {
        name = "git";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/git";
      }
      {
        name = "git-auto-fetch";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/git-auto-fetch";
      }
      {
        name = "golang";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/golang";
      }
      {
        name = "history";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/history";
      }
      {
        name = "podman";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/podman";
      }
      {
        name = "python";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/python";
      }
      {
        name = "rust";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/rust";
      }
      {
        name = "sudo";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo";
      }
      {
        name = "uv";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/uv";
      }
      {
        name = "z";
        src = "${oh-my-zsh}/share/oh-my-zsh/plugins/z";
      }
    ];

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    shellAliases = {
      ll = "eza -la --icons --git --group-directories-first";
      ls = "eza --icons --git";
      la = "eza -a --icons --git";
      lt = "eza --tree --icons --level=2";
      cat = "bat --style=plain";
      v = "nvim";
      g = "git";
      j = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
      ".4" = "cd ../../../..";
      c = "clear";
      r = "sudo nixos-rebuild switch --flake /etc/nixos#comrade";
      u = "nix flake update";
    };

    initContent = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Bind history-substring-search for UP/DOWN keys
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Alt+Left/Right word navigation
      bindkey '^[[1;3D' backward-word
      bindkey '^[[1;3C' forward-word

      # Point Docker clients at the Podman socket
      export DOCKER_HOST="unix:///run/user/1000/podman/podman.sock"

      # Ensure ZSH cache dir exists (used by oh-my-zsh plugins for completions)
      [[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
    '';
  };
}
