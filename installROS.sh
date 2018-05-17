#!/bin/bash

set -o nounset
set -o errexit

ARCH=$(uname -i)
RELEASE=$(lsb_release -sc)

if [ "$RELEASE" = "trusty" ]; then
	ROSDISTRO=indigo
	echo "Installing ros-$ROSDISTRO"
elif [ "$RELEASE" = "xenial" ]; then
	ROSDISTRO=kinetic
	echo "Installing ros-$ROSDISTRO"
else
    echo "Installation is not compatible for your platform"
    exit 1
fi

# Setup sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key B01FA116

# Istallation
sudo apt-get update

if [ "$ARCH" = "x86_64" ]; then
echo "Installing ROS-$ROSDISTRO Full Desktop"
    sudo apt-get -y install ros-"$ROSDISTRO"-desktop-full
elif [ "$ARCH" = "aarch64" ]; then
	echo "Installing ROS-$ROSDISTRO Barebones"
	sudo apt-get -y install ros-"$ROSDISTRO"-ros-base
else
	"Installation is not compatible for your platform"
	exit 1
fi

# Initialize rosdep
sudo rosdep init
rosdep update

# Environment setup
echo "source /opt/ros/kinetic/setup.bash" >> "$HOME/.bashrc"
source "$HOME/.bashrc"
source "/opt/ros/$ROSDISTRO/setup.bash"

# Dependencies for building packages
sudo apt-get -y install python-rosinstall python-rosinstall-generator python-wstool build-essential

