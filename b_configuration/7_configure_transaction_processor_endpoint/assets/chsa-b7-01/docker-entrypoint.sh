#!/bin/bash

set -e

sudo sed -i 's/localhost/chsa-b7-00/g' /etc/default/sawtooth-intkey-tp-python
sudo sed -i 's/localhost/chsa-b7-00/g' /etc/default/sawtooth-xo-tp-python

sudo systemctl enable sawtooth-intkey-tp-python
sudo systemctl enable sawtooth-xo-tp-python

exec "$@"