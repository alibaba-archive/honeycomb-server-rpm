#!/bin/sh

PKG_NAME=$1
if  [ -z $PKG_NAME ]; then
    echo "pkg name missing,example: ./test PKG_NAME"
    exit 1
fi
# docker run -it --rm  -v $(pwd)/RPMS:/rpms -p 9999:9999 -p 80:80 centos:7
docker run -it --rm  -v $(pwd)/RPMS:/rpms centos:7 /bin/bash -c \
    "yum install perl -y && cd /rpms/x86_64 && rpm -i $PKG_NAME && cd /home/admin/honeycomb && su admin -c \"./bin/server_ctl start\" && curl http://localhost:9999 && ls /usr/lib/systemd/system"
