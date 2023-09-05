#!/bin/bash

SCRIPT_VERSION="2.1"
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

# Logger function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> script.log
}

# Docker operations
stop_all_containers() {
    docker stop $(docker ps -aq) && log "Stopped all containers" || log "Failed to stop all containers"
}

start_all_containers() {
    docker start $(docker ps -aq) && log "Started all containers" || log "Failed to start all containers"
}

# k3s operations
install_k3s() {
    curl -fsL https://get.k3s.io | sh -s - --node-name control.k8s && log "k3s installation successful" || log "k3s installation failed"
}

uninstall_k3s() {
    /usr/local/bin/k3s-uninstall.sh && log "k3s uninstalled" || log "Failed to uninstall k3s"
}

start_k3s() {
    systemctl start k3s && log "k3s started" || log "Failed to start k3s"
}

stop_k3s() {
    systemctl stop k3s && log "k3s stopped" || log "Failed to stop k3s"
}

view_k3s_logs() {
    journalctl -u k3s | tail -n 20
}

view_k3s_info() {
    kubectl cluster-info && log "Viewed k3s info" || log "Failed to retrieve k3s info"
}

# Display results and main menu
display_result() {
  dialog --colors --backtitle "Docker and k3s Management Script v$SCRIPT_VERSION" \
    --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

main_menu() {
    while true; do
        RUNNING_CONTAINERS=$(docker ps --format '{{.Names}}' | tr '\n' ', ' | sed 's/,$//')
        RUNNING_K3S_NODES=$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//')
        RUNNING_K3S_PODS=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | awk '{print $2}' | tr '\n' ', ' | sed 's/,$//')

        exec 3>&1
        choice=$(dialog \
            --colors \
            --backtitle "Docker and k3s Management Script v$SCRIPT_VERSION" \
            --title "Main Menu" \
            --clear \
            --cancel-label "Exit" \
            --menu "\nRunning Docker Containers: $RUNNING_CONTAINERS\nRunning k3s Nodes: $RUNNING_K3S_NODES\nRunning k3s Pods: $RUNNING_K3S_PODS\n" \
            $HEIGHT $WIDTH 8 \
            "1" "Stop Docker containers" \
            "2" "Start Docker containers" \
            "3" "Install k3s" \
            "4" "Uninstall k3s" \
            "5" "Start k3s" \
            "6" "Stop k3s" \
            "7" "View k3s info" \
            "8" "View last k3s logs" \
            2>&1 1>&3)

        exit_status=$?
        exec 3>&-
        
        case $exit_status in
            $DIALOG_CANCEL)
                clear
                log "Script closed."
                exit
                ;;
            $DIALOG_ESC)
                clear
                log "Script closed."
                exit 1
                ;;
        esac
        
        case $choice in
            1) 
                stop_all_containers
                result="All Docker containers have been stopped."
                ;;
            2)
                start_all_containers
                result="All Docker containers have been started."
                ;;
            3)
                install_k3s
                result="k3s installation attempted."
                ;;
            4)
                uninstall_k3s
                result="k3s uninstalled."
                ;;
            5)
                start_k3s
                result="k3s started."
                ;;
            6)
                stop_k3s
                result="k3s stopped."
                ;;
            7)
                view_k3s_info
                result="Displayed k3s information."
                ;;
            8)
                result=$(view_k3s_logs)
                ;;
        esac
        display_result "Result"
    done
}

main_menu
