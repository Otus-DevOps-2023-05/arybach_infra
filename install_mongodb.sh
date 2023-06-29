#!/bin/bash

# Import the MongoDB public GPG key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

# Add the MongoDB repository
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Update the package repository
sudo apt-get update

# Install MongoDB
sudo apt-get install -y mongodb-org

# Start MongoDB service
sudo systemctl start mongod

# Enable MongoDB service to start on system boot
sudo systemctl enable mongod

# Check MongoDB service status
sudo systemctl status mongod
