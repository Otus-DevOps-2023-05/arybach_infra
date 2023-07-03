#!/bin/bash

# Wait for 10 seconds before running apt update
sleep 10

# Update system packages
sudo apt update

# Install Ruby and Bundler
sudo apt install -y ruby-full bundler build-essential
