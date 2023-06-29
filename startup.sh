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

### Expose port 9292 with TCP protocol
yc firewall rule create \
 --name reddit-app-9292 \
 --network-name default \
 --direction ingress \
 --source-range 0.0.0.0/0 \
 --destination-port 9292 \
 --protocol tcp

# Run install_ruby.sh
./install_ruby.sh

# Run install_mongodb.sh
./install_mongodb.sh

# Run deploy.sh
./deploy.sh
