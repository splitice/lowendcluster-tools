#!/bin/bash

# The URL to a website outputting a list of IPs
# One IP per line ONLY
FW_URL="$1"
IPSET_NAME="ip_whitelist"

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function iptables_once {
	iptables -D $@
	iptables -A $@
}

function ip6tables_once {
	ip6tables -D $@
	ip6tables -A $@
}

wget "$FW_URL" -O /tmp/fw.list

if [[ $? ]]; then
	echo "Failed to fetch IP List"
	exit 1
fi

OTHER_IPSET = $(ipset save | grep -v $IPSET_NAME)
cat /tmp/fw.list | {
	echo "ipset create $IPSET_NAME hash:ip";
	while read ip; do
		if valid_ip $ip; then
			echo "ipset add $IPSET_NAME $ip"
		fi
	done;
	echo "$OTHER_IPSET";
} | ipset restore

rm /tmp/fw.list

iptables_once INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables_once INPUT -m set ! --match-set $IPSET_NAME src -j DROP
ip6tables_once INPUT -j DROP