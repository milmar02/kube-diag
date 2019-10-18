#!/bin/bash
set -e

export POD_IP=$(ip a | grep inet | grep eth0 | awk '{print $2}'| cut -d "/" -f1 )
export POD_NETMASK=$(ip a | grep inet | grep eth0 | awk '{print $2}'| cut -d "/" -f2 )
export POD_DEFGW=$(ip route | grep default | awk '{print $3}')
export POD_UID=$(id -u)

/usr/local/openresty/nginx/sbin/nginx -g "daemon off;"

