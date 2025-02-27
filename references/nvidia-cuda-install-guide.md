8. CUDA Cross-Platform Environment
Cross development for arm64-sbsa is supported on Ubuntu 20.04, Ubuntu 22.04, Ubuntu 24.04, KylinOS 10, RHEL 8, RHEL 9, and SLES 15.

Cross development for arm64-Jetson is only supported on Ubuntu 22.04

We recommend selecting a host development environment that matches the supported cross-target environment. This selection helps prevent possible host/target incompatibilities, such as GCC or GLIBC version mismatches.

8.1. CUDA Cross-Platform Installation
Some of the following steps may have already been performed as part of the native installation sections. Such steps can safely be skipped.

These steps should be performed on the x86_64 host system, rather than the target system. To install the native CUDA Toolkit on the target system, refer to the native installation sections in Package Manager Installation.

8.1.1. Ubuntu
Perform the pre-installation actions.

Choose an installation method: local repo or network repo.

8.1.1.1. Local Cross Repo Installation for Ubuntu
Install repository meta-data package with:

sudo dpkg -i cuda-repo-cross-<arch>-<distro>-X-Y-local-<version>*_all.deb
where <arch>-<distro> should be replaced by one of the following:

aarch64-ubuntu2204

sbsa-ubuntu2004

sbsa-ubuntu2204

sbsa-ubuntu2404

8.1.1.2. Network Cross Repo Installation for Ubuntu
The new GPG public key for the CUDA repository is 3bf863cc. This must be enrolled on the system, either using the cuda-keyring package or manually; the apt-key command is deprecated and not recommended.

Install the new cuda-keyring package:

wget https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<arch>/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
where <distro>/<arch> should be replaced by one of the following:

ubuntu2004/cross-linux-sbsa

ubuntu2204/cross-linux-aarch64

ubuntu2204/cross-linux-sbsa

ubuntu2404/cross-linux-sbsa

8.1.1.3. Common Installation Instructions for Ubuntu
Update the Apt repository cache:

sudo apt-get update
Install the appropriate cross-platform CUDA Toolkit:

For arm64-sbsa:

sudo apt-get install cuda-cross-sbsa
For arm64-Jetson

sudo apt-get install cuda-cross-aarch64
For QNX:

sudo apt-get install cuda-cross-qnx
Perform the post-installation actions.