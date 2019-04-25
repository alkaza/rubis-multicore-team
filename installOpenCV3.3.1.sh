#!/bin/bash

echo "Prerequisites for Ubuntu Linux"
sudo apt-add-repository universe
sudo apt-get update
sudo apt-get install -y \
    cmake \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng12-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk2.0-dev \
    pkg-config

# Python 2.7
sudo apt-get install -y python-dev python-numpy python-py python-pytest -y

# Python 3.0 (optional)
sudo apt-get install python3-dev python3-numpy python3-py python3-pytest

# GStreamer support
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 

echo "Getting source code"
# OpenCV repository
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout -b v3.3.1 3.3.1

# OpenCV Extra (data for tests and demos)
cd $HOME
git clone https://github.com/opencv/opencv_extra.git
cd opencv_extra
git checkout -b v3.3.1 3.3.1

echo "Prepare build area"
cd $HOME/opencv
mkdir build
cd build

echo "Configure OpenCV for building (Ubuntu Desktop)"
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_LIBRARY_PATH=/usr/local/cuda-8.0/lib64/stubs \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DENABLE_PRECOMPILED_HEADERS=OFF \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -DCUDA_ARCH_BIN=6.1 \
    -DCUDA_ARCH_PTX="" \
    -DCUDA_GENERATION="Pascal" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
    ../ | tee cmake.log

echo "Build OpenCV with make"
make -j4

echo "Sanity check"
make -j4
make

echo "Test OpenCV"
# make test ARGS="--verbose --parallel 4" | tee make_test_verbose.log
make test ARGS="--parallel 4" | tee make_test.log

echo "Install OpenCV"
read -p "Press [enter] to continue"
sudo make install
