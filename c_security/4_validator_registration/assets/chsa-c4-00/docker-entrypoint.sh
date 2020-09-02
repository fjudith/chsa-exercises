#!/bin/bash

set -e

if [ ! -f /etc/sawtooth/keys/validator.priv ]; then
    sudo sawadm keygen
fi

mkdir -p /home/${USER}/.sawtooth/keys

if [ ! -f /home/${USER}/.sawtooth/keys/${USER}.priv ]; then
    sudo sawtooth keygen --key-dir /home/${USER}/.sawtooth/keys ${USER}
    sudo chown ${USER}:${USER} /home/${USER}/.sawtooth/keys/${USER}.p*
fi

# sudo sawset genesis --key /home/${USER}/.sawtooth/keys/${USER}.priv
# sudo sawadm genesis config-genesis.batch

if [ ! -f config-genesis.batch ]; then
    sudo sawset genesis --key /etc/sawtooth/keys/validator.priv \
    -o config-genesis.batch
fi

if [ ! -f config.batch ]; then
    sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
    sawtooth.consensus.algorithm=poet \
    sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" \
    sawtooth.poet.valid_enclave_measurements="$(poet enclave measurement)" \
    sawtooth.poet.valid_enclave_basenames="$(poet enclave basename)" \
    -o config.batch
fi

if [ ! -f /tmp/poet.batch ]; then
    sudo -u sawtooth poet registration create -k /etc/sawtooth/keys/validator.priv \
    -o /tmp/poet.batch
fi

if [ ! -f poet-settings.batch ]; then
    sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
    sawtooth.publisher.max_batches_per_block=200 \
    sawtooth.poet.target_wait_time=15 \
    sawtooth.poet.initial_wait_time=15 \
    sawtooth.poet.key_block_claim_limit=100000 \
    sawtooth.poet.ztest_minimum_win_count=100000 \
    -o poet-settings.batch
fi

if [ ! -f /var/lib/sawtooth/config.batch ]; then
    sudo sawadm genesis config-genesis.batch config.batch poet-settings.batch /tmp/poet.batch
fi

sudo systemctl enable sawtooth-validator
sudo systemctl enable sawtooth-settings-tp
sudo systemctl enable sawtooth-identity-tp
sudo systemctl enable sawtooth-poet-validator-registry-tp
sudo systemctl enable sawtooth-rest-api

sudo systemctl enable sawtooth-intkey-tp-python
sudo systemctl enable sawtooth-xo-tp-python

sudo systemctl enable telegraf

sudo sed -i "s/#\(SAWTOOTH_VALIDATOR_ARGS=\)/\1-vv/g"  /etc/default/sawtooth-validator
sudo sed -i "s/\(SAWTOOTH_IDENTITY_TP_ARGS=-v\)\s\(.*\)/\1v \2/g"  /etc/default/sawtooth-identity-tp
sudo sed -i "s/\(SAWTOOTH_SETTINGS_TP_ARGS=-v\)\s\(.*\)/\1v \2/g"  /etc/default/sawtooth-settings-tp

exec "$@"