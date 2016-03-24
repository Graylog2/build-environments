#!/bin/bash

set -e
export DOCKER_HOST=${DOCKER_HOST:-'unix:///var/run/docker.sock'}

# Copy files, we don't want to download all the time, to Docker context
files=( /usr/share/phantomjs/latest/bin/phantomjs )

for DISTRIBUTION in */
do
  for CONTAINER_NAME in ${DISTRIBUTION}*
  do
    for file in "${files[@]}"
    do
      cp "$file" .
    done
    if [ -d "${CONTAINER_NAME}" ]; then
      LEGACY_ID=$(docker images | grep $CONTAINER_NAME | awk '{print $3}')
      if [[ ! -z "$LEGACY_ID" ]]; then
        echo "Delete existing image ${LEGACY_ID} - ${CONTAINER_NAME}"
        docker rmi -f ${CONTAINER_NAME}
      fi
      echo "Building environment for ${CONTAINER_NAME}"
      docker build --force-rm=true -t ${CONTAINER_NAME} ${CONTAINER_NAME}
    fi;
  done
done
