-- ── Window rules ───────────────────────────────────

-- Float rules ───────────────────────────────────────────────────
-- System configuration tools
hl.rule({ class = "pavucontrol" }, { float = true })
hl.rule({ class = "blueman-manager" }, { float = true })
hl.rule({ class = "nwg-look" }, { float = true })
hl.rule({ class = "qt5ct" }, { float = true })
hl.rule({ class = "qt6ct" }, { float = true })

-- Picture-in-Picture (float + pin on top)
hl.rule({ title = "Picture.in.Picture" }, { float = true, pin = true })

-- Sharing indicator (e.g. screen share in browsers)
hl.rule({ title = "Sharing Indicator" }, { float = true })

-- Brave browser - start tiled on workspace 2 (optional)
-- hl.rule({ class = "brave-browser" },   { workspace = "2", tile = true })

-- XWayland drag fix (allow drag-and-drop from X11 to Wayland)
hl.rule({ class = "^.*$" }, { xwayland = { use_nearest_neighbor = false } })

-- ── Misc ──────────────────────────────────────────────────────
-- vfr is already set in core; this file can be extended as needed.
