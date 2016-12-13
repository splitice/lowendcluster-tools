#!/bin/bash

function call_relative {
	DIR=$(dirname "$0")
	cd $DIR
	bash $@
}

CONFIG_FILE=$(dirname "$0")/includes/config.sh
if [[ -f "$CONFIG_FILE" ]]; then
	source $(dirname "$0")/includes/config.sh
fi