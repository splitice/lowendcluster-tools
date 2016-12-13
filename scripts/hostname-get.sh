#!/bin/bash

source $(dirname "$0")/includes/common.sh

HOSTNAME=$(hostname --fqdn)

if [[ "$HOSTNAME" == "vultr" ]]; then
	call_relative hostname-get-vultr.sh
fi