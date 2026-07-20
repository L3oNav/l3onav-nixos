{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };

      terminal = {
        shell = {
          program = "${pkgs.tmux}/bin/tmux";
          args = [ "new-session" "-A" "-s" "main" ];
        };
      };

      env = {
        TERM = "alacritty";
      };

      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        opacity = 0.92;
        decorations = "full";
        title = "Alacritty";
      };

      font = {
        size = 11;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold Italic";
        };
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        vi_mode_style = {
          shape = "Beam";
          blinking = "On";
        };
        unfocused_hollow = false;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "0xffffff";
      };

      mouse = {
        hide_when_typing = true;
        bindings = [
          {
            mouse = "Right";
            action = "ExpandSelection";
          }
        ];
      };

      hints = {
        enabled = [
          {
            regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)\\S+";
            command = "xdg-open";
            post_processing = true;
            mouse = { enabled = true; };
            binding = { key = "U"; mods = "Control|Shift"; };
          }
          {
            regex = "(?-u:\\b\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\b)";
            command = "xdg-open";
            post_processing = true;
            mouse = { enabled = true; };
            binding = { key = "I"; mods = "Control|Shift"; };
          }
        ];
      };

      keyboard = {
        bindings = [
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
          {
            key = "Insert";
            mods = "Shift";
            action = "PasteSelection";
          }
          {
            key = "Key0";
            mods = "Control";
            action = "ResetFontSize";
          }
          {
            key = "Equals";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Plus";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "PageUp";
            mods = "Shift";
            action = "ScrollPageUp";
          }
          {
            key = "PageDown";
            mods = "Shift";
            action = "ScrollPageDown";
          }
          {
            key = "Home";
            mods = "Shift";
            action = "ScrollToTop";
          }
          {
            key = "End";
            mods = "Shift";
            action = "ScrollToBottom";
          }
        ];
      };

      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xebdbb2";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
        };
        dim = {
          black = "0x1d2021";
          red = "0x9d0006";
          green = "0x79740e";
          yellow = "0xb57614";
          blue = "0x076678";
          magenta = "0x8f3f71";
          cyan = "0x427b58";
          white = "0x7c6f64";
        };
      };
    };
  };
}
