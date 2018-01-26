#!/bin/sh

IMAGE_NAME=`docker images | grep rpmbuild | awk '{print $1}'`
FORCE_REBUILD=1
if [  -z "$IMAGE_NAME" -a "$IMAGE_NAME" != " " ]; then
    echo "build contianer"
    docker build . -t rpmbuild
fi
BASE=$(cd "$(dirname "$0")"; pwd)
RPMS_PATH=$BASE/RPMS
SOURCES_PATH=$BASE/SOURCES
SPECS_PATH=$BASE/SPECS
mkdir -p $RPMS_PATH $SOURCES_PATH $SPECS_PATH
echo $BASE $RPMS_PATH $SOURCES_PATH $SPECS_PATH
docker run -it  --rm  -v $RPMS_PATH:/root/rpmbuild/RPMS \
    -v $SOURCES_PATH:/root/rpmbuild/SOURCES \
    -v $SPECS_PATH:/root/rpmbuild/SPECS \
    rpmbuild