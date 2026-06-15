-- ── Keybindings ────────────────────────────────────

local super = "SUPER"
local shift = "SHIFT"
local ctrl = "CTRL"
local alt = "ALT"

-- ── Launch applications ────────────────────────────────────────
hl.bind({ super, "Return" }, "exec", "alacritty")        -- Terminal
hl.bind({ super, "B" }, "exec", "brave")                 -- Browser
hl.bind({ super, "E" }, "exec", "pcmanfm")               -- File manager
hl.bind({ super, "Space" }, "exec", "rofi -show drun")   -- App launcher

-- ── Window management (vim-style hjkl) ─────────────────────────
hl.bind({ super, "H" }, "movefocus", "l")         -- Focus left
hl.bind({ super, "L" }, "movefocus", "r")         -- Focus right
hl.bind({ super, "K" }, "movefocus", "u")         -- Focus up
hl.bind({ super, "J" }, "movefocus", "d")         -- Focus down

hl.bind({ super, shift, "H" }, "movewindow", "l") -- Move window left
hl.bind({ super, shift, "L" }, "movewindow", "r") -- Move window right
hl.bind({ super, shift, "K" }, "movewindow", "u") -- Move window up
hl.bind({ super, shift, "J" }, "movewindow", "d") -- Move window down

-- ── Workspaces 1–9 ─────────────────────────────────────────────
for i = 1, 9 do
    hl.bind({ super, tostring(i) }, "workspace", tostring(i))
    hl.bind({ super, shift, tostring(i) }, "movetoworkspace", tostring(i))
end

-- ── Window actions ─────────────────────────────────────────────
hl.bind({ super, "Q" }, "killactive")            -- Kill active window
hl.bind({ super, "F" }, "fullscreen", "1")       -- Toggle fullscreen
hl.bind({ super, "V" }, "togglefloating")        -- Toggle floating
hl.bind({ super, "P" }, "pseudo")                -- Toggle pseudo-tile
hl.bind({ super, "S" }, "togglesplit")           -- Toggle split direction

-- ── Media keys ─────────────────────────────────────────────────
hl.bind({ "", "XF86AudioPlay" }, "exec", "playerctl play-pause")
hl.bind({ "", "XF86AudioPause" }, "exec", "playerctl play-pause")
hl.bind({ "", "XF86AudioNext" }, "exec", "playerctl next")
hl.bind({ "", "XF86AudioPrev" }, "exec", "playerctl previous")
hl.bind({ "", "XF86AudioStop" }, "exec", "playerctl stop")

hl.bind({ "", "XF86AudioMute" }, "exec", "pactl set-sink-mute @DEFAULT_SINK@ toggle")
hl.bind({ "", "XF86AudioRaiseVolume" }, "exec", "pactl set-sink-volume @DEFAULT_SINK@ +5%")
hl.bind({ "", "XF86AudioLowerVolume" }, "exec", "pactl set-sink-volume @DEFAULT_SINK@ -5%")

-- ── Brightness ─────────────────────────────────────────────────
hl.bind({ "", "XF86MonBrightnessUp" }, "exec", "brightnessctl set +10%")
hl.bind({ "", "XF86MonBrightnessDown" }, "exec", "brightnessctl set 10%-")

-- ── Screenshots ────────────────────────────────────────────────
hl.bind({ "", "Print" }, "exec", "grim -g \"$(slurp)\" - | wl-copy")               -- Region
hl.bind({ shift, "Print" }, "exec", "grim - | wl-copy")                            -- Full screen

-- ── Resize submap (Super + R) ──────────────────────────────────
hl.bind({ super, "R" }, "submap", "resize")
hl.submap("resize", {
    { { "H" },      "resizeactive", "-30 0" },
    { { "L" },      "resizeactive", "30 0" },
    { { "K" },      "resizeactive", "0 -30" },
    { { "J" },      "resizeactive", "0 30" },
    { { "Escape" }, "submap",       "global" },
})

-- ── Logout submap (Super + Escape) ─────────────────────────────
hl.bind({ super, "Escape" }, "submap", "logout")
hl.submap("logout", {
    { { "C" },        "exec",   "hyprctl reload" },      -- Reload config
    { { "E" },        "exec",   "hyprctl dispatch exit" }, -- Exit Hyprland
    { { "L" },        "exec",   "hyprlock" },            -- Lock screen
    { { "S" },        "exec",   "systemctl suspend" },   -- Suspend
    { { "R" },        "exec",   "systemctl reboot" },    -- Reboot
    { { shift, "S" }, "exec",   "systemctl poweroff" },  -- Poweroff
    { { "Escape" },   "submap", "global" },
})

-- ── Power / Lock shortcuts ─────────────────────────────────────
hl.bind({ super, shift, "Q" }, "exec", "wlogout")  -- Logout menu
hl.bind({ ctrl, alt, "L" }, "exec", "hyprlock")    -- Lock screen

-- ── Mouse bindings ─────────────────────────────────────────────
hl.bindm({ super, "mouse:272" }, "movewindow")   -- Super + LMB drag
hl.bindm({ super, "mouse:273" }, "resizewindow") -- Super + RMB resize
