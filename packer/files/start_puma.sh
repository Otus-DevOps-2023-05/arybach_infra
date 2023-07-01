#!/bin/bash

# Change to the Reddit app directory
cd ~/reddit

# Start the Puma server as a systemd service
sudo /usr/local/bin/puma -d
