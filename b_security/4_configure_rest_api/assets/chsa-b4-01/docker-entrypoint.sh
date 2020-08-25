#!/bin/bash

set -e

sudo rm -f /etc/default/sawtooth-settings-tp

sudo systemctl enable sawtooth-settings-tp

exec "$@"