#!/bin/bash

REGISTRATION_URI="$1"
REGISTRATION_TYPE="$2"
REGISTRATION_INTERFACE="${3:-eth0}"

function do_register {
        local hostname=$(/bin/hostname --fqdn)
        curl "$REGISTRATION_URI?ip=$1&hostname=$hostname&type=$REGISTRATION_TYPE"
}

REGISTER_ADDR=$(/sbin/ifconfig "$REGISTRATION_INTERFACE" | grep "inet addr" | awk '{print substr($2,6)}')

if [[ ! -z "$REGISTER_ADDR" ]]; then
        do_register "$REGISTER_ADDR"
fi
