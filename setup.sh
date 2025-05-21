#!/bin/bash
set -eux

# Update system
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# Install Docker
sudo apt-get install -y docker.io
sudo usermod -aG docker vagrant

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Start Minikube with Docker driver
sudo -u vagrant -H bash -c '
  minikube start --driver=docker
  eval $(minikube -p minikube docker-env)
  cd /vagrant/app && docker build -t flask-app .
  kubectl apply -f /vagrant/k8s
'
