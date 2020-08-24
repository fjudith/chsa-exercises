#!/bin/bash

set -e

if ![ -f /etc/sawtooth/validator.toml ]; then
    sudo sawadm keygen
fi

sudo systemctl enable sawtooth-validator
sudo systemctl enable sawtooth-rest-api
sudo systemctl enable sawtooth-settings-tp

exec "$@"