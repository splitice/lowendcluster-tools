#!/bin/bash

PRIVATE_IP=$(ifconfig eth1 | grep "inet addr" | awk '{print substr($2,6)}')
HOSTNAME=$(hostname --fqdn)

{
	echo "[mysqld]";
	echo "bind-address=$PRIVATE_IP";
	echo "wsrep_node_address=\"$PRIVATE_IP\"";
	echo "wsrep_node_name=\"$HOSTNAME\"";
}  > /etc/mysql/conf.d/zcluster.cnf

