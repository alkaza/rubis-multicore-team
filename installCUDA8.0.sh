#!/bin/bash

set -o nounset
set -o errexit

echo "Before installing CUDA, any previous installations that could conflict"
echo "should be uninstalled. This will not affect systems which have not had"
echo "CUDA installed previously, or systems where the installation method"
echo "has been preserved (RPM/Deb vs. Runfile)."
echo "Use the following command to uninstall a Toolkit runfile installation:"
echo "    $ sudo /usr/local/cuda-X.Y/bin/uninstall_cuda_X.Y.pl"
echo "Use the following command to uninstall a Driver runfile installation:"
echo "    $ sudo /usr/bin/nvidia-uninstall"
echo "Use the following commands to uninstall a RPM/Deb installation:"
echo "    $ sudo apt-get --purge remove <package>"

read -p "Would you like to continue? (yes/no): " -r answer
case $answer in
    [Y/y]*) ;;
    *) exit 1 ;;
esac
echo

echo "Pre-installation actions"
ARCH=$(uname -i)
echo "Architecture: $ARCH"
if [ "$ARCH" != "x86_64" ]; then
    echo "Installation is not compatible for your platform"
    exit 1
fi

DISTRIB=$(lsb_release -i -s)
echo "Lunux Distibution: $DISTRIB"
if [ "$DISTRIB" != "Ubuntu" ]; then
    echo "Installation is not compatible for your platform"
    exit 1
fi

RELEASE=$(lsb_release -r -s)
echo "Version: $RELEASE"
case "$RELEASE" in
    "16.04") 
        DEB="cuda-repo-ubuntu1604_8.0.61-1_amd64.deb"
        DEB_LINK="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/$DEB" 
        IMD5="1f4dffe1f79061827c807e0266568731" ;;
    "14.04") 
        DEB="cuda-repo-ubuntu1404_8.0.61-1_amd64.deb"
        DEB_LINK="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/$DEB"
        IMD5="cf41f620dcebccd7a669d8ef3f31aeac" ;;
    *) 
        echo "Installation is not compatible for your platform"
        exit 1 ;;
esac
echo

echo "Verify CUDA-capable GPU:"
if ! lspci | grep -i nvidia ; then
    sudo update-pciids
    if ! lspci | grep -i nvidia ; then
        echo "Unable to find NVIDIA GPU"
        exit 1
    fi
fi
echo

echo "Verify gcc installation:"
if ! gcc --version ; then
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install build-essential
    if ! gcc --version ; then
        echo "Unable to install gcc"
        exit 1
    fi
fi
echo

echo "Verify correct kernel headers:"
KERNEL=$(uname -r)
echo "Kernel version: $KERNEL"
sudo apt-get install linux-headers-$KERNEL
echo

echo "Installing NVIDIA CUDA Toolkit 8.0"
if ! nvcc -V | grep -iq V8.0.61 ; then
    echo "Downloading $DEB from $DEB_LINK"
    if [ ! -f "$HOME/Downloads/$DEB" ]; then
        wget -P "$HOME/Downloads" "$DEB_LINK"
    else
        echo "File already exists"
    fi
    echo

    echo "Download verification:"
    echo "IMD5 for $DEB: $IMD5"
    if ! md5sum "$HOME/Downloads/$DEB" | grep -iq "$IMD5" ; then
        echo "MD5 checksum mismatch, downloading again"
        rm "$HOME/Downloads/$DEB"
        wget $DEB_LINK
        if ! md5sum "$HOME/Downloads/$DEB" | grep -iq "$IMD5" ; then
            echo "Unable to download"
            exit 1
        fi
    else
        echo "IMD5 for $DEB: $IMD5"
    fi
    echo

    sudo dpkg -i "$HOME/Downloads/$DEB"
    sudo apt-get update
    sudo apt-get install cuda=8.0.61-1
else 
    echo "NVIDIA CUDA Toolkit 8.0 already installed"
fi

if ! grep -qi cuda-8.0 ~/.bashrc ; then
    echo "export PATH=/usr/local/cuda-8.0/bin:$PATH" >> "$HOME/.bashrc"
    source "$HOME/.bashrc" 
fi
echo

echo "Post-installation actions (recommended)"
echo "Verify driver version:"
cat /proc/driver/nvidia/version
DRIVER=$(grep -oP '(?<=Kernel Module\s{2})(\d{3})(?=[.])' /proc/driver/nvidia/version)
echo

echo "Verify CUDA Toolkit version:"
nvcc -V
echo

echo "Running writable CUDA samples"
if [ ! -d "$HOME/NVIDIA_CUDA-8.0_Samples" ]; then
    cuda-install-samples-8.0.sh "$HOME"
fi

if [ ! -d "$HOME/NVIDIA_CUDA-8.0_Samples/bin" ]; then
    cd "$HOME/NVIDIA_CUDA-8.0_Samples"
    find "$HOME/NVIDIA_CUDA-8.0_Samples" -type f -execdir sed -i "s/UBUNTU_PKG_NAME = \"nvidia-367\"/UBUNTU_PKG_NAME = \"nvidia-$DRIVER\"/g" {} +
    make
fi

cd "$HOME/NVIDIA_CUDA-8.0_Samples/bin/x86_64/linux/release"
./deviceQuery
echo
echo
./bandwidthTest
