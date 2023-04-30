#!/bin/bash

function check_root {
    amiroot=$(whoami)
    if [ "$amiroot" != "root" ]
    then
        echo "You must run this as root."
        exit
    fi
}

function remove_container_runtimes {
    pkgs=""
    if command -v docker &> /dev/null
    then
        pkgs+="docker "
    fi
    if command -v podman &> /dev/null
    then
        pkgs+="podman "
    fi

    if [ -z "$pkgs" ]
    then
        echo "No container runtimes found."
        return
    fi

    echo "The following container runtimes will be removed: $pkgs"
    read -p "Do you want to remove them? (y/n) " ans
    if [ "$ans" == "y" ]
    then
        echo "Removing container runtimes..."
        yum -y remove $pkgs
        echo "Container runtimes removed."
    else
        echo "Skipping container runtime removal."
    fi
}

function install_docker {
    if command -v docker &> /dev/null || command -v podman &> /dev/null
    then
        echo "A container runtime is already installed. Skipping installation."
        return
    fi

    echo "Installing Docker..."
    yum -y install docker
    echo "Docker installed successfully."
}

function add_users_to_docker_group {
    usernames=()
    echo "Enter the username of the user(s) who will need Docker permissions to run without sudo:"
    echo "Enter d to indicate Done entering docker users."

    while true; do
        read -p "Enter username: " username
        if [ "$username" == "d" ]
        then
            break
        fi

        id -u "$username" &> /dev/null
        if [ "$?" -ne 0 ]
        then
            echo "User $username not found."
        else
            echo "$username added."
            usernames+=("$username")
        fi
    done

    if [ ${#usernames[@]} -eq 0 ]
    then
        echo "No users added to the Docker group."
        return
    fi

    echo "The following users will be added to the Docker group: ${usernames[@]}"
    read -p "Do you want to add them to the Docker group? (y/n) " ans
    if [ "$ans" == "y" ]
    then
        for username in "${usernames[@]}"
        do
            usermod -aG docker "$username"
        done
        echo "Users added to the Docker group."
    else
        echo "Skipping adding users to the Docker group."
    fi
}

function start_docker {
    systemctl start docker
    systemctl enable docker
    echo "Docker daemon started and will automatically start at boot."
}

check_root
remove_container_runtimes
install_docker
add_users_to_docker_group
start_docker

