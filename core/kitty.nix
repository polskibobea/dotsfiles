{pkgs, ...}:
{
hjem.users.bober.packages = [ pkgs.kitty ];
hjem.users.bober.files.".config/kitty/kitty.conf".text = ''
    font_family      Lilex Nerd Font
    font_size        12.0
    cursor_shape beam
    cursor_blink_interval 0
    confirm_os_window_close 0
    hide_window_decorations yes
    background              #000000
    foreground              #cdd6f4
    cursor                  #f5e0dc
    selection_background    #585b70
    selection_foreground    #cdd6f4
    color0  #45475a
    color8  #585b70
    color1  #f38ba8
    color9  #f38ba8
    color4  #89b4fa
    color12 #89b4fa
    color5  #cba6f7
    color13 #cba6f7
  '';
}
