
# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
exec --no-startup-id dex --autostart --environment i3

# The combination of xss-lock, nm-applet and pactl is a popular choice, so
# they are included here as an example. Modify as you see fit.

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
#exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id nm-applet

# Bar
#exec --no-startup-id "~/bin/eww daemon && ~/bin/eww open bar_1"
exec --no-startup-id "/usr/bin/polybar mainbar-i3 -c ~/.config/polybar/config.ini"

# Wallpaper
exec --no-startup-id "/usr/bin/feh --bg-fill ~/wallpapers/0258.jpg"

# Compositor
exec --no-startup-id picom

#####################
# Keyboard
###
# Set keyboard layout
exec --no-startup-id setxkbmap no
# Reset modifier keys
#exec -no-startup-id setxkbmap -option
