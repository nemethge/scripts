#!/bin/bash

# Listázás az összes futó konténer ID-járól
containers=$(docker ps -aq)

# Ellenőrzés, hogy vannak-e futó konténerek
if [ -z "$containers" ]; then
    echo "Nincsenek futó Docker konténerek."
else
    # Leállítás az összes konténert
    docker stop $containers

    # Törlés az összes konténert
    docker rm $containers

    echo "Az összes Docker konténer leállítva és törölve."
fi
