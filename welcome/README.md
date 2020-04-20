# Autostart terminal and README.txt
Create a file `/home/scamv/.config/autostart/welcome_scamv.desktop` and mark it executable. Contents:
```
[Desktop Entry]
Name=Welcome SCAM-V
Exec=/home/scamv/scamv/introduction/welcome/welcome_scamv.sh
Icon=/usr/share/pixmaps/xterm-color_48x48.xpm
Terminal=false
Type=Application
StartupNotify=true
NoDisplay=true
```

Append the following to `/home/scamv/.bashrc`:
```
# SCAM-V setup
export HOLBA_OPT_DIR="/home/scamv/scamv/HolBA_opt"
export HOLBA_LOGS_DIR="/home/scamv/scamv/HolBA_logs"
source "/home/scamv/scamv/HolBA/env.sh"
cd "/home/scamv/scamv"
clear
```

