#!/bin/bash

if [ ! -e 'honeycomb-server-1.0.3-1.tar.gz' ]; then
    echo "error: install tar not find!"
    exit 
fi

getent group admin>/dev/null || groupadd -r admin
getent passwd admin>/dev/null || \
    useradd -r -g admin -d /home/admin  \
    -c "admin account for honeycomb" admin
mkdir -p /home/admin
chown admin:admin /home/admin
su admin -c "cp ./honeycomb-server-1.0.3-1.tar.gz /home/admin && cd /home/admin && tar xvf honeycomb-server-1.0.3-1.tar.gz"

chown root:admin /home/admin/nginx/sbin/nginx
chmod 6775 /home/admin/nginx/sbin/nginx
