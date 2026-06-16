{ config, pkgs, ... }:

let
  hyprDir = "${config.xdg.configHome}/hypr";
in
{
  # ── NVIDIA environment variables for Wayland ─────
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # ── hy3 plugin loader (.conf loads plugin, then sources Lua) ──
  xdg.configFile."hypr/hyprland.conf".text = ''
    plugin = ${pkgs.hyprlandPlugins.hy3}/lib/libhy3.so
    source = hyprland.lua
  '';

  # ── Hyprland (Lua-based) ─────────────────────────
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  # ── Modules ──────────────────────────────────────
  xdg.configFile."hypr/modules/env.lua".source = ./modules/env.lua;
  xdg.configFile."hypr/modules/monitors.lua".source = ./modules/monitors.lua;
  xdg.configFile."hypr/modules/core.lua".source = ./modules/core.lua;
  xdg.configFile."hypr/modules/autostart.lua".source = ./modules/autostart.lua;
  xdg.configFile."hypr/modules/binds.lua".source = ./modules/binds.lua;
  xdg.configFile."hypr/modules/rules.lua".source = ./modules/rules.lua;
  xdg.configFile."hypr/modules/hy3.lua".source = ./modules/hy3.lua;

  # ── Hypridle ─────────────────────────────────────
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 600
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

    listener {
        timeout = 900
        on-timeout = hyprlock
    }

    listener {
        timeout = 1800
        on-timeout = systemctl suspend
    }
  '';

  # ── Hyprlock ─────────────────────────────────────
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = false
        ignore_empty_input = true
    }

    background {
        monitor =
        color = rgba(30, 30, 46, 1.0)
    }

    input-field {
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.33
        dots_spacing = 0.15
        dots_center = true
        outer_color = rgba(b4befe, 0.5)
        inner_color = rgba(30, 30, 46, 0.9)
        font_color = rgb(cdd6f4)
        fade_on_empty = false
        placeholder_text = Password...
        hide_input = false
        position = 0, 20
        halign = center
        valign = center
    }

    label {
        text = cmd[update:1000] date +"%H:%M"
        color = rgba(cdd6f4, 1)
        font_size = 64
        position = 0, -200
        halign = center
        valign = center
    }
  '';

  # ── Hyprpaper ────────────────────────────────────
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    ipc = off
  '';

  # ── Waybar ───────────────────────────────────────
  xdg.configFile."waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 32,
      "spacing": 4,
      "modules-left": ["hyprland/workspaces", "hyprland/window"],
      "modules-center": ["clock"],
      "modules-right": ["tray", "pulseaudio", "network", "cpu", "memory", "battery"],
      "hyprland/workspaces": {
        "format": "{icon}",
        "on-click": "activate",
        "all-outputs": false,
        "persistent-workspaces": {
          "1": [], "2": [], "3": [], "4": [], "5": [],
          "6": [], "7": [], "8": [], "9": []
        }
      },
      "clock": { "format": "{:%a %b %d  %H:%M}", "tooltip-format": "<big>{:%Y %B}</big>" },
      "pulseaudio": { "format": "{icon} {volume}%", "format-muted": " M", "on-click": "pavucontrol" },
      "network": { "format-wifi": " {signalStrength}%", "format-ethernet": " {ifname}", "format-disconnected": "  " },
      "cpu": { "format": " {usage}%" },
      "memory": { "format": " {}%" },
      "battery": { "format": "{icon}  {capacity}%", "format-charging": " {capacity}%", "format-plugged": " {capacity}%" },
      "tray": { "spacing": 10 }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * { font-family: "FiraCode Nerd Font Mono", "Noto Sans CJK SC", sans-serif; font-size: 13px; }
    window#waybar { background: rgba(30,30,46,0.85); color: #cdd6f4; }
    #workspaces button { padding: 0 5px; color: #6c7086; border-radius: 4px; }
    #workspaces button.active { color: #cdd6f4; background: #585b70; }
    #workspaces button:hover { background: #45475a; }
    #clock { padding: 0 12px; color: #f5c2e7; font-weight: bold; }
    #pulseaudio, #network, #cpu, #memory, #battery, #tray { padding: 0 10px; }
    #pulseaudio { color: #89b4fa; }
    #network { color: #a6e3a1; }
    #cpu { color: #fab387; }
    #memory { color: #cba6f7; }
    #battery { color: #f9e2af; }
    tooltip { background: #1e1e2e; border: 1px solid #585b70; border-radius: 6px; }
  '';

  # ── Dunst ────────────────────────────────────────
  xdg.configFile."dunst/dunstrc".text = ''
    [global]
      monitor = 0
      follow = mouse
      width = 350
      height = 150
      origin = top-right
      offset = 10x42
      scale = 0
      notification_limit = 5
      progress_bar = true
      progress_bar_height = 4
      progress_bar_frame_width = 0
      progress_bar_min_width = 100
      progress_bar_max_width = 350
      indicate_hidden = yes
      transparency = 0
      separator_height = 1
      padding = 12
      horizontal_padding = 16
      text_icon_padding = 8
      frame_width = 2
      frame_color = "#89b4fa"
      separator_color = frame
      sort = yes
      font = FiraCode Nerd Font Mono 11
      line_height = 3
      markup = full
      format = "<b>%s</b>\n%b"
      alignment = left
      vertical_alignment = center
      show_age_threshold = 60
      ellipsize = middle
      ignore_newline = false
      stack_duplicates = true
      hide_duplicate_count = false
      show_indicators = yes
      icon_position = left
      min_icon_size = 32
      max_icon_size = 64
      sticky_history = yes
      history_length = 20
      browser = brave
      always_run_script = true
      corner_radius = 8
      mouse_left_click = do_action, close_current
      mouse_middle_click = close_all
      mouse_right_click = close_current

    [urgency_low]
      background = "#1e1e2e"
      foreground = "#cdd6f4"
      timeout = 4

    [urgency_normal]
      background = "#1e1e2e"
      foreground = "#cdd6f4"
      timeout = 6

    [urgency_critical]
      background = "#1e1e2e"
      foreground = "#f38ba8"
      frame_color = "#f38ba8"
      timeout = 0
  '';

  # ── wlogout ──────────────────────────────────────
  xdg.configFile."wlogout/layout".text = ''
    {
      "label" : "logout",
      "action" : "hyprctl dispatch exit",
      "text" : "Logout",
      "keybind" : "l"
    },
    {
      "label" : "lock",
      "action" : "hyprlock",
      "text" : "Lock",
      "keybind" : "k"
    },
    {
      "label" : "reboot",
      "action" : "systemctl reboot",
      "text" : "Reboot",
      "keybind" : "r"
    },
    {
      "label" : "shutdown",
      "action" : "systemctl poweroff",
      "text" : "Shutdown",
      "keybind" : "s"
    },
    {
      "label" : "suspend",
      "action" : "systemctl suspend",
      "text" : "Suspend",
      "keybind" : "u"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * { background-image: none; }
    window {
      background-color: rgba(30, 30, 46, 0.9);
      font-family: "FiraCode Nerd Font Mono";
    }
    button {
      color: #cdd6f4;
      background: rgba(49, 50, 68, 0.8);
      border: 2px solid #89b4fa;
      border-radius: 12px;
      margin: 8px;
      font-size: 16px;
    }
    button:focus, button:hover {
      background: rgba(88, 91, 112, 0.8);
      border-color: #b4befe;
    }
  '';
}
