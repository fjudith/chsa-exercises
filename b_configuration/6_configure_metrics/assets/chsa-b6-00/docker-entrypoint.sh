#!/bin/bash

set -e

if [ ! -f /etc/sawtooth/keys/validator.priv ]; then
    sudo sawadm keygen
fi

mkdir -p /home/${USER}/.sawtooth/keys

sudo sawtooth keygen --key-dir /home/${USER}/.sawtooth/keys ${USER}
sudo chown ${USER}:${USER} /home/${USER}/.sawtooth/keys/${USER}.p*

sudo systemctl enable sawtooth-validator
sudo systemctl enable sawtooth-settings-tp
sudo systemctl enable sawtooth-rest-api

sudo systemctl enable sawtooth-intkey-tp-python
sudo systemctl enable sawtooth-xo-tp-python

sudo systemctl enable telegraf

exec "$@"