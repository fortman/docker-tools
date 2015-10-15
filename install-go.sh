#!/bin/bash -ex


#apt-get install -y wget gcc cpp
apt-get update
apt-get install -y -q wget gcc
pushd /usr/src
wget https://storage.googleapis.com/golang/go1.4.2.src.tar.gz
tar -xzf go1.4.2.src.tar.gz
pushd go/src
PLATFORM="linux/amd64"
GOOS=${PLATFORM%/*} GOARCH=${PLATFORM##*/} ./make.bash --no-clean 2>&1;
cp ../bin/* /usr/bin
