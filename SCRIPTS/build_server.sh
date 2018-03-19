#!/bin/bash

# clone honeycomb-server master branch and run `honeycomb package` for linux

REPO_URL="https://github.com/node-honeycomb/honeycomb-server.git"
REPO_NAME="honeycomb-server"
VER=$1
echo "build version: $VER"
if  [ -z $VER ]; then
    echo "version missing.example: ./build_server 0.0.1"
    exit 1
fi

checkCmd() {
    if ! [ -x "$(command -v $1)" ]; then
        echo "$1 not find,please check you env" >&2
        exit 1
    fi
}

checkCmd git 

mkdir -p run && cd run

rm -rf $REPO_NAME

if ! [ -d $REPO_NAME ]; then
    git clone $REPO_URL
fi

cd $REPO_NAME

git checkout master

git pull

checkCmd make

echo "run docker build for linux"

docker run  --rm  -v $(pwd):/source node:8 /bin/bash -c "cd /source/ && make package"

cd out/

mkdir honeycomb-server_$VER
cp release/* honeycomb-server_$VER
tar cvf honeycomb-server_$VER.tgz honeycomb-server_$VER

cp honeycomb-server_$VER.tgz ../../../SOURCES

echo "now honeycomb-server_$VER.tgz is in your SOURCES dir"

