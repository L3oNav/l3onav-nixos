{ config, pkgs, ... }:

{
  imports = [ ];

  # ── NVIDIA environment variables for Wayland ──
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Let Hyprland handle cursor; no WLR_NO_HARDWARE_CURSORS needed
  };

  # ── Hyprland config ──
  xdg.configFile."hypr/hyprland.conf".text = ''
    # ── Monitors ──────────────────────────────────
    # Detect automatically; customize with `hyprctl monitors`
    monitor=,preferred,auto,auto

    # ── Environment ───────────────────────────────
    env = XCURSOR_SIZE,24
    env = QT_QPA_PLATFORM,wayland;xcb
    env = QT_QPA_PLATFORMTHEME,qt5ct
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = GDK_BACKEND,wayland,x11
    env = CLUTTER_BACKEND,wayland
    env = SDL_VIDEODRIVER,wayland
    env = MOZ_ENABLE_WAYLAND,1
    env = _JAVA_AWT_WM_NONREPARENTING,1

    # ── Input method (fcitx5) ─────────────────────
    exec-once = fcitx5 --replace

    # ── Autostart ─────────────────────────────────
    exec-once = waybar
    exec-once = dunst
    exec-once = hyprpaper
    exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || true
    exec-once = gnome-keyring-daemon --start --components=secrets || true

    # ── General ───────────────────────────────────
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(89b4faee) rgba(b4befecc) 45deg
        col.inactive_border = rgba(585b70aa)
        layout = dwindle
        cursor_inactive_timeout = 3
    }

    # ── Decoration ────────────────────────────────
    decoration {
        rounding = 10
        blur {
            enabled = true
            size = 5
            passes = 2
            new_optimizations = on
        }
        drop_shadow = true
        shadow_range = 12
        shadow_offset = 3 3
        col.shadow = rgba(1e1e2e99)
    }

    # ── Animations ────────────────────────────────
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # ── Layout (dwindle) ─────────────────────────
    dwindle {
        pseudotile = true
        preserve_split = true
        no_gaps_when_only = false
    }

    # ── Input ─────────────────────────────────────
    input {
        kb_layout = us
        kb_variant =
        kb_options =
        follow_mouse = 1
        sensitivity = 0
        touchpad {
            natural_scroll = true
        }
    }

    # ── Gestures ──────────────────────────────────
    gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
    }

    # ── Misc ──────────────────────────────────────
    misc {
        force_default_wallpaper = 2
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = true
        vrr = 1
    }

    # ── Binds ─────────────────────────────────────
    $mainMod = SUPER

    # Apps
    bind = $mainMod, RETURN, exec, alacritty
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, pcmanfm
    bind = $mainMod, R, exec, rofi -show drun
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, P, pseudo,
    bind = $mainMod, F, fullscreen,
    bind = $mainMod, T, togglesplit,

    # Screenshot
    bind = , PRINT, exec, grimblast copy area
    bind = $mainMod, PRINT, exec, grimblast copy active
    bind = $mainMod SHIFT, PRINT, exec, grimblast copy output

    # Lock
    bind = $mainMod, L, exec, hyprlock

    # Move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Move windows
    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d

    # Resize
    binde = $mainMod CTRL, left, resizeactive, -20 0
    binde = $mainMod CTRL, right, resizeactive, 20 0
    binde = $mainMod CTRL, up, resizeactive, 0 -20
    binde = $mainMod CTRL, down, resizeactive, 0 20

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move to workspace
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll workspaces
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Special workspace (scratchpad)
    bind = $mainMod, S, togglespecialworkspace,
    bind = $mainMod SHIFT, S, movetoworkspace, special

    # Media keys
    binde = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness
    binde = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

    # ── Window rules ──────────────────────────────
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(blueman-manager)$
    windowrule = float, ^(nwg-look)$
    windowrule = float, ^(qt5ct)$
    windowrule = float, ^(qt6ct)$
    windowrule = float, title:^(Picture-in-Picture)$
    windowrule = tile, ^(brave)$

    windowrulev2 = float, class:^(org.pulseaudio.pavucontrol)$
    windowrulev2 = float, class:^(blueman-manager)$

    # ── Submap for logout ─────────────────────────
    bind = $mainMod SHIFT, M, exec, wlogout
  '';

  # ── Waybar config ───────────────────────────────
  xdg.configFile."waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 32,
      "spacing": 4,
      "modules-left": ["hyprland/workspaces", "hyprland/window"],
      "modules-center": ["clock"],
      "modules-right": ["tray", "pulseaudio", "network", "cpu", "memory", "battery"],
      "hyprland/workspaces": { "format": "{icon}", "on-click": "activate" },
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

  # ── Hyprpaper config ────────────────────────────
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    ipc = off
  '';

  # ── Hyprlock config ─────────────────────────────
  xdg.configFile."hypr/hyprlock.conf".text = ''
    background { color = rgba(30,30,46,1.0) }
    input-field {
      size = 250, 50
      outline_thickness = 3
      dots_size = 0.33
      dots_spacing = 0.15
      dots_center = true
      outer_color = rgba(b4befe, 0.5)
      inner_color = rgba(30,30,46,0.9)
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
      color = rgba(cdd6f4,1)
      font_size = 64
      position = 0, -200
      halign = center
      valign = center
    }
  '';

  # ── Dunst config ────────────────────────────────
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

  # ── wlogout config ──────────────────────────────
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
