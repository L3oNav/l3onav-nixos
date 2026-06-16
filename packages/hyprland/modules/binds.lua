local mainMod = "SUPER"
local hy3 = hl.plugin.hy3

-- ── Launch apps ──────────────────────────────────
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("pcmanfm"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("rofi -show window"))

-- ── Window management (hy3 dispatchers) ──────────
hl.bind(mainMod .. " + Q", hy3.kill_active())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hy3.change_group("toggletab"))
hl.bind(mainMod .. " + SHIFT + T", hy3.change_group("opposite"))

-- ── hy3: make splits ─────────────────────────────
hl.bind(mainMod .. " + SHIFT + H", hy3.make_group("h"))
hl.bind(mainMod .. " + SHIFT + V", hy3.make_group("v"))
hl.bind(mainMod .. " + SHIFT + B", hy3.make_group("tab"))

-- ── Monitor switching ────────────────────────────
hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "r" }))

-- ── Vim-style focus (h/j/k/l) via hy3 ────────────
hl.bind(mainMod .. " + H", hy3.move_focus("l"))
hl.bind(mainMod .. " + J", hy3.move_focus("d"))
hl.bind(mainMod .. " + K", hy3.move_focus("u"))
hl.bind(mainMod .. " + L", hy3.move_focus("r"))

-- ── Vim-style window swap via hy3 ────────────────
hl.bind(mainMod .. " + SHIFT + J", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + K", hy3.move_window("u"))

-- ── Arrow fallbacks ──────────────────────────────
hl.bind(mainMod .. " + left", hy3.move_focus("l"))
hl.bind(mainMod .. " + down", hy3.move_focus("d"))
hl.bind(mainMod .. " + up", hy3.move_focus("u"))
hl.bind(mainMod .. " + right", hy3.move_focus("r"))
hl.bind(mainMod .. " + SHIFT + left", hy3.move_window("l"))
hl.bind(mainMod .. " + SHIFT + down", hy3.move_window("d"))
hl.bind(mainMod .. " + SHIFT + up", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + right", hy3.move_window("r"))

-- ── hy3 tab navigation ───────────────────────────
hl.bind(mainMod .. " + Tab", hy3.focus_tab({ direction = "r", wrap = true }))
hl.bind(mainMod .. " + SHIFT + Tab", hy3.focus_tab({ direction = "l", wrap = true }))

-- ── hy3 expand/shrink ────────────────────────────
hl.bind(mainMod .. " + SHIFT + E", hy3.expand("expand"))
hl.bind(mainMod .. " + SHIFT + W", hy3.expand("shrink"))
hl.bind(mainMod .. " + SHIFT + R", hy3.expand("base"))

-- ── hy3 equalize ─────────────────────────────────
hl.bind(mainMod .. " + SHIFT + Space", hy3.equalize({ workspace = true }))

-- ── Resize submap ────────────────────────────────
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- ── Screenshots ──────────────────────────────────
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy active"))
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))

-- ── Lock / Logout ────────────────────────────────
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("wlogout"))
hl.bind("CONTROL + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- ── Workspaces 1-9 ───────────────────────────────
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- ── Workspace scroll (mouse on bar) ──────────────
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ── Media keys ───────────────────────────────────
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- ── Brightness ───────────────────────────────────
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

-- ── Mouse bindings (drag to move, right-drag to resize) ──
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Logout submap ────────────────────────────────
hl.bind(mainMod .. " + Escape", hl.dsp.submap("logout"))
hl.define_submap("logout", function()
    hl.bind("C", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
    end)
    hl.bind("E", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exit())
    end)
    hl.bind("L", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("hyprlock"))
    end)
    hl.bind("S", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("systemctl suspend"))
    end)
    hl.bind("R", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("systemctl reboot"))
    end)
    hl.bind("SHIFT + S", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("systemctl poweroff"))
    end)
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)
