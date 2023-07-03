#!/bin/bash

### Install git
sudo apt install -y git

### Clone app code
git clone -b monolith https://github.com/express42/reddit.git

### Change to the app directory
cd reddit

### Install app dependencies
bundle install

### Launch app
puma -d

### Check if the app is running
ps aux | grep puma
