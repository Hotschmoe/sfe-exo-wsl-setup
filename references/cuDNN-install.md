Download Installer for Linux Ubuntu 24.04 x86_64
The base installer is available for download below.

Base Installer	
Installation Instructions:
wget https://developer.download.nvidia.com/compute/cudnn/9.7.1/local_installers/cudnn-local-repo-ubuntu2404-9.7.1_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2404-9.7.1_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2404-9.7.1/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn
To install for CUDA 11, perform the above configuration but install the CUDA 11 specific package:
sudo apt-get -y install cudnn-cuda-11
To install for CUDA 12, perform the above configuration but install the CUDA 12 specific package:
sudo apt-get -y install cudnn-cuda-12