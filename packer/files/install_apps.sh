#!/bin/bash

# Update the package repository
sudo apt-get update

# Install Git
sudo apt-get install -y git

# Clone the Reddit repository
git clone -b monolith https://github.com/express42/reddit.git
cd reddit

# Install the Ruby dependencies
bundle install
