{pkgs, ...}:
{
  hjem.users.bober = {
    packages = [ pkgs.hyprland pkgs.hyprshot pkgs.wofi];
     files.".config/hypr/hyprland.lua".text = ''
      hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.monitor({
  output   = "DP-1",
  mode     = "1920x1080@60",
  position = "0x0",
  scale    = 1,
})

hl.config({
  input = {
    kb_layout  = "pl",
    kb_variant = ",qwerty",
    kb_options = "grp:alt_shift_toggle",
    touchpad = {
      tap_to_click   = true,
      natural_scroll = true,
    },
  },
  general = {
    gaps_in     = 5,
    gaps_out    = 10,
    border_size = 2,
  },
})

hl.on("hyprland.start", function()
  hl.exec_cmd("quickshell -c mybar")
  hl.exec_cmd("hyprpaper")
end)

local M = "SUPER"

hl.bind(M .. " + Space", hl.dsp.exec_cmd("kitty"))
hl.bind(M .. " + Q",     hl.dsp.window.close())
hl.bind(M .. " + E",     hl.dsp.exec_cmd("wofi --show drun"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })

hl.bind("Print",        hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(M .. " + Print",       hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd("hyprshot -m output"))

hl.bind(M .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(M .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(M .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(M .. " + down",  hl.dsp.focus({ direction = "down"  }))

hl.bind(M .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(M .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(M .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(M .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))

hl.bind(M .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(M .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
  local key = i % 10
  hl.bind(M .. " + " .. key,          hl.dsp.focus({ workspace = i }))
  hl.bind(M .. " + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }))
end
          '';
  };
}
