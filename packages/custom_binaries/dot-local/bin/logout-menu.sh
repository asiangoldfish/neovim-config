#!/usr/bin/bash

#sass logout-menu.scss logout-menu.css
export GTK_THEME="HighContrast"

yad --title='logout menu' \
    --button="Logout:pkill -u $(whoami)" \
    --button='Reboot:systemctl reboot' \
    --button='Power Off:systemctl poweroff' \
    --borders=10
