#!/bin/bash

# This script is used to install the nVidia linux driver and CUDA for use in a 
# headless compute envvironment..


# Install some dependencies:
sudo apt-get install build-essential linux-headers-`uname -r` linux-source-`uname -r`


cd ~/Downloads




# Download and install the driver
wget -P ~/Downloads http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run

chmod +x NVIDIA-Linux-x86_64-346.35.run

# Run the nVidia installer. If it asks to update any x-configurations, don't 
# accept. We only want the driver for headless compute operations.
./NVIDIA-Linux-x86_64-346.35.run -a --update --no-x-check --no-nouveau-check --no-opengl-files --dkms --no-distro-scripts





# Download and install CUDA
wget -P ~/Downloads http://us.download.nvidia.com/XFree86/Linux-x86_64/346.35/NVIDIA-Linux-x86_64-346.35.run

chmod +x cuda_6.5.14_linux_64.run

# Extract CUDA so we don't have to muck about with the driver install
./cuda_6.5.14_linux_64.run -extract=`pwd`

# Set some environment variables so the install succeeds
export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/cuda/lib64:/usr/local/cuda-6.5/lib64
export PATH=$(PATH):/usr/local/cuda/bin:/usr/local/cuda-6.5/bin

# Run the CUDA installer without prompting
./cuda-linux64-rel-6.5.14-18749181.run -noprompt





# Reinstall xorg opensource drivers in case anything got messed up before
sudo apt-get install --reinstall \
        xserver-xorg-video-intel \
        xserver-xorg-video-ati \
        xserver-xorg-video-nouveau