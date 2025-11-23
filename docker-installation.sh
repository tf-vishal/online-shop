#!/bin/bash
set -e
if [ "$(id -u)" -ne 0 ]; then
    echo "this script must be run as root or with sudo."
    exit 1
fi

function arch_distro {
    pacman -Syu --noconfirm #This updates the system to latest package
    function arch_docker_download {
        pacman -S docker --noconfirm #This will install docker

        systemctl start docker.service #This will start docker daemon
        systemctl enable docker.service #Enabling docker service

        usermod -aG docker $USER # Will add user into docker grp 
        newgrp docker #Refreshin grp

        echo "Docker has been installed successfully"
    }

    function arch_compose_download {
        pacman -S docker-compose --noconfirm # Installing docker compose

        echo "Docker compose installed"
    }

    arch_docker_download
    arch_compose_download
}


echo "Looking for the distribution"
if (grep -i "arch" /etc/os-release); 
then (echo "This is arch based distro")
        arch_distro
else
    echo "This is not Arch-Based Distro"
fi

