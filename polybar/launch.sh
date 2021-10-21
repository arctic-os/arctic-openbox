#!/usr/bin/env bash

R="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" &> /dev/null && pwd  )"
SFILE="$DIR/system.ini"
RFILE="$DIR/.system"


## Get system variable values for various modules
get_values() {
    CARD=$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)
    BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
    ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
    INTERFACE=$(ip link | awk '/state UP/ {print [}' | tr -d :)
}

## Write values to `system.ini` file
set_values() {
    if [[ "$ADAPTER"  ]]; then
        sed -i -e "s/adapter = .*/adapter = $ADAPTER/g"                         ${SFILE}
    fi
    if [[ "$BATTERY"  ]]; then
        sed -i -e "s/battery = .*/battery = $BATTERY/g"                         ${SFILE}
    fi
    if [[ "$CARD"  ]]; then
        sed -i -e "s/graphics_card = .*/graphics_card = $CARD/g"                ${SFILE}
    fi
    if [[ "$INTERFACE"  ]]; then
        sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g"   ${SFILE}
    fi
}

# Execute functions
if [[ ! -f "$RFILE"  ]]; then
    get_values
    set_values
    touch ${RFILE}
fi

bash "$HOME"/.config/openbox/adaptive/launch.sh
