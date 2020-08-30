#!/bin/bash

set -e

ARRAY[0]="chsa-c4-00"
ARRAY[1]="chsa-c4-01"
ARRAY[2]="chsa-c4-02"

SIZE=${#ARRAY[@]}

set +e

while true; do

    INDEX=$(($RANDOM % $SIZE))
    URL="http://${ARRAY[$INDEX]}:8008"
    KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
    VALUE=${RANDOM}

    echo "Running command: intkey set ${KEY} ${VALUE} --url \"${URL}\""

    intkey set ${KEY} ${VALUE} --url ${URL}
    
    sleep 0.$[ ( $RANDOM % 15 ) + 1 ]s
done
