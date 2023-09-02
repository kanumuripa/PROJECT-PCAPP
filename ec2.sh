#!/bin/bash

# Script to install all required softwares and ec2 instance.
sudo echo "kubectl" >/etc/hostname

#aws cli installation:

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt-get update

sudo apt-get install unzip

unzip awscliv2.zip 

sudo ./aws/install

#---------------------------------------
#aws configuration:
#------------------

#sudo aws configure
#
#
#us-east-1
#json

#---------------------------------------
#Kubectl installation:
#---------------------
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl

mkdir -p ~/.local/bin

mv ./kubectl ~/.local/bin/kubectl

#kubectl version --client --output=yaml

#--------------------------------------
#eksctl installation
ARCH=amd64

PLATFORM=$(uname -s)_$ARCH


curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

#-----------------------------------------------

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm

#------------------------------
#Ansible installation
#------------------------------

sudo apt update

sudo apt install software-properties-common -y

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install ansible -y

sudo apt install mysql-client -y