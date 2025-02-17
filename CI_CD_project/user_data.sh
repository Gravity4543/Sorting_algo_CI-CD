#!/bin/bash
#this is installation of docker
sudo apt update -y

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sudo apt update -y

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


apt-cache policy docker-ce

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# this is installation of kubctl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


# this is installation of minikube

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
sudo install minikube-linux-amd64 /usr/local/bin/minikube 


echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# web seerver conf 
# echo "updating"
# sudo apt update -y
# echo "installing"
# sudo apt install -y apache2 git
# echo "enable firewall"
# echo y | sudo ufw enable 
# echo "allow traffic"
# sudo ufw allow 'apache'
# sudo ufw allow OpenSSH
# echo "allow traffic"
# rm -rf /var/www/html/index.html
# cd /tmp/
# git clone https://github.com/dharshakch97/sort-visualizer.git
# cd sort-visualizer/
# cp * -r /var/www/html/
# systemctl restart apache2
# rm -rf /tmp/sort-visualizer/


# CLONIG GIT REPO IN WORKDIR
git clone https://github.com/dharshakch97/sort-visualizer.git ./website

touch /tmp/provisioned.ok

