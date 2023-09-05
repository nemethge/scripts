#!/bin/bash

# Function to list and select containers
select_container() {
    echo "Select a container from the list below:"
    select container in $(docker ps -a --format "{{.Names}}"); do
        if [ -n "$container" ]; then
            echo "Selected container: $container"
            break
        else
            echo "Invalid selection"
        fi
    done
}

# Function to check which container is using a specific port
check_port_usage() {
    local port=$1
    docker ps --format "{{.Names}}: {{.Ports}}" | grep $port
}

# Main menu
while true; do
    clear
    echo "╔══════════════════════════════════╗"
    echo "║ Docker Container Management Menu ║"
    echo "╚══════════════════════════════════╝"
    echo "1. List containers"
    echo "2. Start a container"
    echo "3. Stop a container"
    echo "4. Exit"
    echo -n "Choose an option: "
    read option

    case $option in
        1)
            docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
            read -p "Press Enter to continue..."
            ;;
        2)
            select_container
            if ! docker start $container 2>&1 | tee /tmp/docker_error.log; then
                echo "Error starting container $container"
                # Check if the error is related to port binding
                if grep -q "address already in use" /tmp/docker_error.log; then
                    port=$(grep -oP 'listen tcp4 0.0.0.0:\K\d+' /tmp/docker_error.log)
                    echo "Port $port is already in use by the following container(s):"
                    check_port_usage $port
                fi
                read -p "Press Enter to continue..."
            fi
            ;;
        3)
            select_container
            if ! docker stop $container; then
                echo "Error stopping container $container"
                read -p "Press Enter to continue..."
            fi
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid choice"
            read -p "Press Enter to continue..."
            ;;
    esac
done
