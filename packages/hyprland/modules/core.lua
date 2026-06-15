-- ── Core Hyprland settings ─────────────────────────

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_options = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(89b4faee)", "rgba(b4befecc)" },
                angle = 45,
            },
            inactive_border = "rgba(585b70aa)",
        },
        layout = "dwindle",
        cursor_inactive_timeout = 3,
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 12,
            offset = "3 3",
            color = "rgba(1e1e2e99)",
        },
    },
    animations = {
        enabled = true,
        bezier = {
            { name = "myBezier", points = { 0.05, 0.9, 0.1, 1.05 } },
        },
        animation = {
            { name = "windows",    style = { kind = "myBezier" }, duration = 7 },
            { name = "windowsOut", style = { kind = "default" },  duration = 5, popin = "80%" },
            { name = "border",     style = { kind = "default" },  duration = 10 },
            { name = "fade",       style = { kind = "default" },  duration = 7 },
            { name = "workspaces", style = { kind = "default" },  duration = 6 },
        },
    },
    dwindle = {
        pseudotile = true,
        preserve_split = true,
        no_gaps_when_only = false,
    },
    gestures = {
        workspace_swipe = true,
        workspace_swipe_fingers = 3,
    },
    misc = {
        force_default_wallpaper = 2,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vfr = true,
        vrr = 1,
    },
    ecosystem = {
        no_update_news = true,
    },
    debug = {
        disable_logs = true,
    },
})
