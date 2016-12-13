#!/bin/bash

PRIVATE_IP=$(ifconfig eth1 | grep "inet addr" | awk '{print substr($2,6)}')

if ! grep -q "bind $PRIVATE_IP" /etc/redis/bind.conf; then
	echo "Updating bind"
	echo "bind $PRIVATE_IP" > /etc/redis/bind.conf
	/etc/init.d/redis-server restart
fi

nodes=("10.129.119.209" "10.129.119.208" "10.129.149.22")

function join_cluster {
	if [[ "$1" != "$PRIVATE_IP" ]]; then
		ruby /root/redis-trib.rb add-node $1:6379 $PRIVATE_IP:6379
		return $?
	fi
}

for ip in "${nodes[@]}"; do
	join_cluster $ip
	if [[ $? == "0" ]]; then
		echo "Joined $ip's cluster"
		exit 0
	fi
done

echo "Can not find cluster, creating"
ruby /root/redis-trib.rb create $PRIVATE_IP:6379 $PRIVATE_IP:6379 --replicas 1
