#!/usr/bin/env bash

compose_v=1.23.2

echo -e "\n${txtblu}Installing docker${txtrst}"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce
systemctl start docker
systemctl enable docker

echo -e "\n${txtblu}Installing docker-compose${txtrst}"
curl -L https://github.com/docker/compose/releases/download/$compose_v/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
