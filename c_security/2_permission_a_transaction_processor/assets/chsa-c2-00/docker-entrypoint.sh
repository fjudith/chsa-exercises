#!/bin/bash

set -e

if [ ! -f /etc/sawtooth/keys/validator.priv ]; then
    sudo sawadm keygen
fi

mkdir -p /home/${USER}/.sawtooth/keys

# sudo sawtooth keygen --key-dir /home/${USER}/.sawtooth/keys ${USER}
# sudo chown ${USER}:${USER} /home/${USER}/.sawtooth/keys/${USER}.p*
sudo sawset genesis --key /home/${USER}/.sawtooth/keys/${USER}.priv
sudo sawadm genesis config-genesis.batch

sudo systemctl enable sawtooth-validator
sudo systemctl enable sawtooth-settings-tp
sudo systemctl enable sawtooth-identity-tp
sudo systemctl enable sawtooth-poet-validator-registry-tp
sudo systemctl enable sawtooth-rest-api

sudo systemctl enable sawtooth-intkey-tp-python
sudo systemctl enable sawtooth-xo-tp-python

sudo systemctl enable telegraf

sudo sed -i "s/#\(SAWTOOTH_VALIDATOR_ARGS=\)/\1-vv/g"  /etc/default/sawtooth-validator
sudo sed -i "s/\(SAWTOOTH_IDENTITY_TP_ARGS=-v\)\(.*\)/\1v\2/g"  /etc/default/sawtooth-identity-tp

sudo mkdir -p /etc/sawtooth/policy
sudo touch /etc/sawtooth/policy/policy.example

cat << EOF | sudo tee -a /etc/sawtooth/policy/policy.example
PERMIT_KEY $(cat /home/${USER}/.sawtooth/keys/${USER}.pub)
DENY_KEY *
EOF
sudo chown sawtooth:sawtooth /etc/sawtooth/policy/policy.example


exec "$@"