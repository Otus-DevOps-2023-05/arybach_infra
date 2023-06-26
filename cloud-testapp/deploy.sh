#!/bin/bash

### Create new compute instance for reddit-app
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key ~/.ssh/tumblebuns.pub

### Install git
sudo apt install -y git

### Clone app code
git clone -b monolith https://github.com/express42/reddit.git

### Install app dependencies
cd reddit && bundle install

### Launch app
puma -d

### Check if the app is running
ps aux | grep puma
