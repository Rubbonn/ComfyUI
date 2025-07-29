#!/usr/bin/bash
# This script sets up an AWS EC2 instance for running a Docker container with Stable Diffusion

# Installing requirements
echo 'Installing requirements...'
sudo apt-get update \
	&& sudo apt-get install -y wget git dkms linux-headers-amd64 linux-headers-cloud-amd64 ca-certificates curl
echo 'Requirements installed successfully.'

# Install Docker
echo 'Installing Docker...'
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get purge -y $pkg; done
sudo install -m 0755 -d /etc/apt/keyrings \
	&& sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
	&& sudo chmod a+r /etc/apt/keyrings/docker.asc \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
	| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
	&& sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
	&& sudo systemctl enable docker.service \
	&& sudo systemctl enable containerd.service
echo 'Docker installed successfully.'

echo 'Installing Nvidia Drivers...'
# Install Nvidia Drivers
sudo echo 'deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware' | sudo tee /etc/apt/sources.list.d/bookworm-non-free.list > /dev/null \
	&& sudo apt-get update \
	&& sudo apt-get install -y nvidia-tesla-driver nvidia-open-kernel-dkms firmware-misc-nonfree \
	&& sudo nvidia-persistenced
echo 'Nvidia Drivers installed successfully.'

# Installing Nvidia Container Toolkit
echo 'Installing Nvidia Container Toolkit...'
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
	&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
	| sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
	| sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
	&& sudo apt-get update \
	&& sudo apt-get install -y nvidia-container-toolkit nvidia-container-toolkit-base libnvidia-container-tools libnvidia-container1 \
	&& sudo nvidia-ctk runtime configure --runtime=docker \
	&& sudo systemctl restart docker
echo 'Nvidia Container Toolkit installed successfully.'
