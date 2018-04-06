#!/bin/bash

echo "Pre-installation actions for Ubuntu 16.04 x84_64 w/ NVIDIA GPU"
echo "Verify CUDA-capable GPU"
lspci | grep -i nvidia
read -p "Press [enter] to continue"

echo "Verify supported version of Linux"
uname -m && cat /etc/*release
read -p "Press [enter] to continue"

echo "Verify gcc installation"
gcc --version
read -p "Press [enter] to continue"

echo "Verify correct kernel headers"
sudo apt-get install linux-headers-$(uname -r)
read -p "Press [enter] to continue"

echo "Download NVIDIA CUDA Toolkit"
cd $HOME/Downloads
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

echo "Package manager installation"
# Install repository meta-data
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
# Update apt repository cache
sudo apt-get update
# Install CUDA 8.0
sudo apt-get install cuda=8.0.61-1

echo "Environment Setup"
export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

echo "Verify driver version"
cat /proc/driver/nvidia/version

echo "Verify installation"
nvidia-smi

