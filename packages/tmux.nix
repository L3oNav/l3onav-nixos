{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    focusEvents = true;
    keyMode = "vi";
    clock24 = true;

    extraConfig = ''
      set-option -ga terminal-overrides ",alacritty:Tc"
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # fix escape lag in neovim
      set-option -sg escape-time 10

      # split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # vim-like pane navigation (no prefix needed with Alt)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # vim-like pane resizing
      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # new windows retain current path
      bind c new-window -c "#{pane_current_path}"

      # quick window switching with prefix + number
      bind 1 select-window -t 1
      bind 2 select-window -t 2
      bind 3 select-window -t 3
      bind 4 select-window -t 4
      bind 5 select-window -t 5
      bind 6 select-window -t 6
      bind 7 select-window -t 7
      bind 8 select-window -t 8
      bind 9 select-window -t 9

      # smarter pane splitting — focus new pane
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      # vi copy mode
      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel

      # clipboard integration (Wayland)
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind C-y run-shell "${pkgs.wl-clipboard}/bin/wl-paste -n 2>/dev/null | tmux load-buffer - \; paste-buffer"

      # update status bar every 15 seconds
      set-option -g status-interval 15

      # smart pane switching with awareness of vim splits
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];

    # Gruvbox dark themed status bar
    extraConfigBeforePlugins = ''
      # -- status bar style --
      set-option -g status-style "fg=#ebdbb2,bg=#282828"
      set-option -g status-left-length 30
      set-option -g status-right-length 80

      # left: session name
      set-option -g status-left "#[fg=#282828,bg=#b8bb26,bold] #S #[fg=#b8bb26,bg=#282828,nobold]"

      # window list in the middle
      set-window-option -g window-status-format "#[fg=#928374,bg=#282828] #I:#W "
      set-window-option -g window-status-current-format "#[fg=#282828,bg=#458588,bold] #I:#W #[fg=#458588,bg=#282828,nobold]"
      set-window-option -g window-status-separator ""

      # right: date + time + hostname
      set-option -g status-right "#[fg=#d79921,bg=#282828] %Y-%m-%d %H:%M #[fg=#b16286,bg=#282828] #h "

      # pane border
      set-option -g pane-border-style "fg=#928374"
      set-option -g pane-active-border-style "fg=#458588"

      # message style
      set-option -g message-style "fg=#ebdbb2,bg=#458588"

      # mode style (copy mode highlight)
      set-option -g mode-style "fg=#282828,bg=#d79921,bold"
    '';
  };
}
