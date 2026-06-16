-- ── hy3 plugin: i3/sway-like manual tiling layout ──
-- https://github.com/outfoxxed/hy3

local hy3 = hl.plugin.hy3

-- ── Plugin settings ──────────────────────────────
hl.config({
    plugin = {
        hy3 = {
            node_collapse_policy = 2,
            group_inset = 10,
            tab_first_window = true,

            tabs = {
                height = 22,
                padding = 6,
                from_top = false,
                radius = 6,
                border_width = 2,
                render_text = true,
                text_center = true,
                text_font = "Sans",
                text_height = 8,
                text_padding = 3,
                blur = true,
                opacity = 1.0,
                colors = {
                    active = "rgba(89b4fa40)",
                    active_border = "rgba(89b4faee)",
                    active_text = "rgba(cdd6f4ff)",
                    inactive = "rgba(49,50,68,40)",
                    inactive_border = "rgba(88,91,112,aa)",
                    inactive_text = "rgba(cdd6f4ff)",
                    urgent = "rgba(f38ba840)",
                    urgent_border = "rgba(f38ba8ee)",
                    urgent_text = "rgba(cdd6f4ff)",
                },
            },

            autotile = {
                enable = true,
                ephemeral_groups = true,
                trigger_width = 0,
                trigger_height = 0,
                workspaces = "all",
            },
        },
    },
})
