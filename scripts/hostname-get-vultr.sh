#!/bin/bash

source $(dirname "$0")/includes/common.sh

IP=$(ifconfig eth0 | grep 'inet addr' | awk '{print substr($2,6)}')

curl -s "https://api.vultr.com/v1/server/list?api_key=$VULTR_API_KEY" | sed 's/SUBID/\n/g' | grep "\"$IP\"" | tail -n-1 | egrep -o '"label":"[^"]+"' | awk '{print substr($0,10,length($0)-10)}'
