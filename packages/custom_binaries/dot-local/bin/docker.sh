#!/usr/bin/env bash

! command -v docker > /dev/null && bash "./setup.sh"

FLAG="$1"
COMMAND='docker.sh'

# Enter flags here

function usage() {
    echo -n "Usage $COMMAND [-h] OPTION

$COMMAND manages Docker containers from an orchestrational level. It allows
actions like deleting and rebuilding containers, and more.

OPTION
    -h, --help                     this page
        --processes                view running containers
        ps						   shorthand for --processes
        --processes-all            view all containers (even if not running)
        ps a					   shorthand for --processes-all
        --stop-processes           stop all running containers
        --build                    [re]build containers. Changes in
                                        take effect.
        --cold-start               stop containers and rebuild them
        --delete-all               delete all volumes, containers, images
        --delete-volumes           delete all volumes currently not in use
        --delete-containers        delete all containers
        --delete-images            delete all images
        --logs                     get the logs of a container
        --shell [CONTAINER_ID]     open a container's shell
"
}

function build() {
    echo "[Re]build containers..."
    sudo docker compose up -d --build
}

function delete_containers() {
    echo "Stopping all containers..."
    sudo docker stop $(sudo docker ps -a -q)

    echo "Deleting all containers..."
    sudo docker rm $(sudo docker ps -a -q)
}

function cold_start() {
    echo "Stopping all containers..."
    sudo docker stop $(sudo docker ps -a -q)

    build
}

function delete_volumes() {
    echo "Delete unused volumes"
    sudo docker volume prune
}

function delete_images() {
    echo "Delete images"
    sudo docker rmi -f $(sudo docker images -aq)
}

function delete_all() {
    delete_containers
    delete_volumes
    delete_images

    sudo docker system prune -a
}

function logs() {
    local containers

    mapfile -t containers < <(docker ps -a --format '{{.Names}}')

    # Print menu
    echo "Container [1-${#containers[@]}]:"
    local i=1
    for name in "${containers[@]}"; do
        echo "[$i] $name"
        ((i++))
    done


    echo "[Q] Abort"

    local input
    read -p "$ " input
    if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
        return
    else
        local index="$((input-1))"

        if (( index < 0 || index >= "${#containers}" )); then
            echo "Invalid selection"
            exit 1
        fi

        local container_name

        container_name="${containers[$index]}"

        sudo docker logs "$container_name" --follow --timestamps
    fi
}

shell() {
    if [ -z "$1" ]; then
        echo "Missing argument CONTAINER_ID"
        exit 1
    fi

    docker exec -it "$1" bash
}

#################
### Arguments ###
#################

# Runs help message if no arguments were found
if [[ $# -eq 0 ]]; then usage; exit; fi

# Checks for flags and runs accordingly
for arg in "$@"; do
    case $arg in
        -h | --help) usage ;;
        ps | --processes ) 
            if [ "$2" == "-a" ]; then
                sudo docker ps -a
            else
                sudo docker ps;
            fi
            exit 0;;
        --processes-all ) sudo docker ps -a; exit 0;;
        --stop-processes) sudo docker stop $(sudo docker ps -a -q) ;;
        --build) build; exit 0;;
        --cold-start ) cold_start; exit 0;;
        --delete-all ) delete_all; exit 0;;
        --delete-volumes ) delete_volumes; exit 0;;
        --delete-containers ) delete_containers; exit 0;;
        --delete-images ) delete_images; exit 0;;
        --logs) logs; exit 0;;
        --shell) shift; shell "$@"; exit 0;;
        * ) echo "Invalid argument '$arg'"; usage; exit 0;;
    esac
    shift
done
