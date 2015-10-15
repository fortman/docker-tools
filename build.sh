#!/bin/bash -ex

mkdir -p logs

DOCKER_INSTALL_COMMAND="/tmp/install-docker-tools.sh"
START_DATE=$(date)
docker build . | tee logs/build.output
#IMG_ID=$(cat logs/build.output | grep "Successfully built" | awk ' { print $NF } ' )
#[ -n ${IMG_ID} ] && docker run -it --privileged ${IMG_ID} ${DOCKER_INSTALL_COMMAND} | tee logs/run.output
#CON_ID=$( docker ps -a --no-trunc=true | awk -v COMMAND="${DOCKER_INSTALL_COMMAND}" ' $3 == "\""COMMAND"\"" { print $1 } ' | head -1 )
#[ -n ${CON_ID} ] && docker commit ${CON_ID}

END_DATE=$(date)
echo "START: ${START_DATE}"
echo "END: ${END_DATE}"
echo "IMG_ID: ${IMG_ID}"
echo "CON_ID: ${CON_ID}"

