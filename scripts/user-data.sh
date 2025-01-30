#!/bin/bash

TMPDIR="/home/ssm-user/tmp"

base_setup(){
    echo "Updating System"
    yum update -y

    echo "Add nvdia toolit to repo"
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
    tee /etc/yum.repos.d/nvidia-container-toolkit.repo

    echo "Adding packages"
    yum install -y gcc make docker nvidia-container-toolkit

    echo "installing kernel-devel"
    yum install -y kernel-devel-$(uname -r)
}

driver_setup(){
    echo "copy nvdia drivers"
    cd ~
    aws s3 cp --recursive s3://ec2-linux-nvidia-drivers/latest/ .

    echo "set file permissions"
    chmod +x NVIDIA-Linux-x86_64*.run
    [ -d "$TMPDIR" ] || mkdir -p "$TMPDIR"
    chmod -R 777 "$TMPDIR"

    echo "Running NVDA driver setup"
    cd /home/ssm-user
    CC=/usr/bin/gcc10-cc ./NVIDIA-Linux-x86_64*.run --tmpdir=$TMPDIR --silent --accept-license --no-questions
}

verify_driver_setup(){
    if ! nvidia-smi -q | head | grep -q "Driver Version"; then
        echo "Driver verification failed. Exiting..."
        exit 1

    echo "disabling GSP"
    touch /etc/modprobe.d/nvidia.conf
    echo "options nvidia NVreg_EnableGpuFirmware=0" | tee --append /etc/modprobe.d/nvidia.conf
}

setup_docker(){
    echo "Setting up docker"
    usermod -a -G docker ec2-user
    systemctl enable docker.service
    systemctl start docker.service
}

nvdia_drivers_docker(){
    echo "Configuring NVIDIA runtime for Docker"
    nvidia-ctk runtime configure --runtime=docker
    systemctl restart docker
}

ollama_setup() {
    echo "Run Ollama container"
    docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama --restart always ollama/ollama
   
    echo "Pull deepseek AI model"
    docker exec -it ollama ollama pull deepseek-r1:14b

    echo "Run Ollama WebUI"
    docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v ollama-webui:/app/backend/data --name ollama-webui --restart always ghcr.io/ollama-webui/ollama-webui:main
}

main(){
    base_setup
    driver_setup
    verify_driver_setup
    setup_docker
    ollama_setup
}

main