#!/usr/bin/env python3

import json

# Add code to generate dynamic inventory here

# Below is the static example
inventory = {
    "app": {
        "hosts": ["appserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    },
    "db": {
        "hosts": ["dbserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    }
}

print(json.dumps(inventory))
