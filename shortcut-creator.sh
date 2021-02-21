#!/bin/sh

gamedir="$(pwd)"

# Check files and create variables
if [ -f "$gamedir/re3" ]; then
    GAME_NAME="re3 - GTA III"
    GAME_EXEC="re3"
    GAME_ICON="Icons/logo-re3.svg"
elif [ -f "$gamedir/reVC" ]; then
    GAME_NAME="reVC - GTA: VC"
    GAME_EXEC="reVC"
    GAME_ICON="Icons/logo-reVC.svg"
else
    notify-send "re3" "Looks like files are not extracted correctly. Please make sure to extract the files to the game's root directory." -i "$gamedir/$GAME_ICON"
    exit 1
fi

# Directories description
[ -z "$XDG_CONFIG_HOME" ] && XDG_CONFIG_HOME="$HOME/.config"
. "$XDG_CONFIG_HOME/user-dirs.dirs"
[ -z "$XDG_DATA_HOME" ] && XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_DESKTOP_DIR" ] && XDG_DESKTOP_DIR="$HOME/Desktop"
appdir="$XDG_DATA_HOME/applications"
desktop_file_app="$appdir/$GAME_NAME.desktop"
desktop_file_desk="$XDG_DESKTOP_DIR/$GAME_NAME.desktop"

# Delete desktop files on -d
if [ "$1" = "-d" ]; then
    rm -f "$desktop_file_desk" "$desktop_file_app"
    exit 0
fi

# Create desktop files
[ ! -d "$appdir" ] && mkdir -p "$appdir"
cd "$(dirname "$0")"
cat << EOM | tee "$desktop_file_app" "$desktop_file_desk"
[Desktop Entry]
Encoding=UTF-8
Name=$GAME_NAME
GenericName=$GAME_NAME
Exec="$gamedir/$GAME_EXEC"
Path=$gamedir
Terminal=false
Icon=$gamedir/$GAME_ICON
Type=Application
Categories=Game;
StartupNotify=true
Comment=Start $GAME_NAME
EOM
chmod +x "$desktop_file_app" "$desktop_file_desk"
