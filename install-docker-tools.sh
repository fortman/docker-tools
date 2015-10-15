#!/bin/bash -ex

function finish {
    CONTAINERS=$(docker ps -a | grep -v "^CONTAINER" | awk ' { print $1 } ' )
    for CONTAINER in ${CONTAINERS}; do
        docker rm ${CONTAINER}
    done
    IMAGES=$(docker images | grep -v "^REPOSITORY" | awk ' { print $3 } ' )
    for IMAGE in ${IMAGES}; do
        docker rmi ${IMAGE}
    done
    service docker stop
    sleep 5
    DM_DEVS=$(dmsetup ls | grep -v "^No" | awk ' { print $1 } ')
    for DM_DEV in ${DM_DEVS}; do
        dmsetup remove /dev/mapper/${DM_DEV}
    done
    while [[ -f /tmp/wait ]]; do
        sleep 10
    done
    rm -rf /var/lib/docker/devicemapper
    rm -rf /usr/src/*
    rm -rf /opt/go/src
}
trap finish EXIT

apt-get update
apt-get install -y -q git mercurial make python-setuptools libyaml-dev python-dev
service docker start
sleep 30
pushd /usr/src
git clone https://github.com/docker/compose
pushd compose
python setup.py install
popd
popd

export PLATFORM="linux/amd64"
export GOOS=${PLATFORM%/*}
export GOARCH=${PLATFORM##*/}

export GOPATH=/opt/go
export GOSRC=/usr/src/go
export PATH=${PATH}:${GOSRC}/bin:${GOPATH}/bin
go get github.com/tools/godep
go get golang.org/x/tools/cmd/vet
mkdir -p ${GOPATH}/src/github.com/docker
pushd ${GOPATH}/src/github.com/docker
git clone https://github.com/docker/machine
git clone https://github.com/docker/swarm
#git clone https://github.com/docker/libnetwork
#git clone https://github.com/docker/distribution
pushd machine
make
cp docker-machine_linux-amd64 /usr/bin/docker-machine
popd
pushd swarm
godep go install .
cp ${GOPATH}/bin/swarm /usr/bin/docker-swarm
popd
#pushd libnetwork
#make
#popd
#godep get github.com/Sirupsen/logrus
#godep get github.com/docker/docker/pkg/tarsum
#godep get github.com/docker/libtrust
#godep get github.com/gorilla/mux
#godep get golang.org/x/net/context
#godep get github.com/codegangsta/cli
#godep get github.com/AdRoll/goamz/aws
#godep get github.com/AdRoll/goamz/cloudfront
#godep get github.com/AdRoll/goamz/s3
#godep get github.com/Azure/azure-sdk-for-go/storage
#godep get github.com/Sirupsen/logrus/formatters/logstash
#godep get github.com/bugsnag/bugsnag-go
#godep get github.com/garyburd/redigo/redis
#godep get github.com/gorilla/handlers
#godep get github.com/stevvooe/resumable
#godep get github.com/stevvooe/resumable/sha256
#godep get github.com/stevvooe/resumable/sha512
#godep get github.com/yvasiyarov/gorelic
#godep get golang.org/x/crypto/bcrypt
#godep get gopkg.in/yaml.v2
#godep get gopkg.in/check.v1

#pushd distribution
#make
#cp bin/registry /usr/bin/docker-registry
#popd



