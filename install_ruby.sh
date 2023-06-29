#!/bin/bash

# Update system packages
sudo apt update

# Install Ruby and Bundler
sudo apt install -y ruby-full build-essential

# Install or update Bundler
gem install bundler
