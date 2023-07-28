#!/bin/bash

# Ellenőrzi, hogy a vbetool telepítve van-e
if ! command -v vbetool &> /dev/null
then
    echo "A vbetool nincs telepítve. Telepítés..."
    sudo apt-get install vbetool -y
fi

# A képernyő be- és kikapcsolása
if [ "$1" == "ki" ]; then
    vbetool dpms off
elif [ "$1" == "be" ]; then
    vbetool dpms on
else
    echo "Hibás kapcsoló. Használja a 'ki' kapcsolót a képernyő kikapcsolásához, és a 'be' kapcsolót a képernyő bekapcsolásához."
fi
