#!/bin/bash

set -eo pipefail

export DOCKER_HOST=${DOCKER_HOST:-'unix:///var/run/docker.sock'}

# Copy files, we don't want to download all the time, to Docker context
files=( /usr/share/phantomjs/latest/bin/phantomjs )

for DISTRIBUTION in */
do
  for CONTAINER_NAME in ${DISTRIBUTION}*
  do
    for file in "${files[@]}"
    do
      cp ${file} "./${CONTAINER_NAME}/"
    done
    if [ -d "${CONTAINER_NAME}" ]; then
      LEGACY_ID=$(docker images | (grep $CONTAINER_NAME || true) | awk '{print $3}')
      echo "##################################################################"
      echo "# Building environment for ${CONTAINER_NAME}"
      echo "##################################################################"
      docker build --force-rm=true -t ${CONTAINER_NAME} ${CONTAINER_NAME}

      NEW_ID=$(docker images | grep $CONTAINER_NAME | awk '{print $3}')

      if [[ -n "$LEGACY_ID" && "$LEGACY_ID" != "$NEW_ID" ]]; then
        echo "Delete old image ${LEGACY_ID} - ${CONTAINER_NAME} (replaced by: ${NEW_ID})"
        docker rmi -f ${CONTAINER_NAME} || true
      fi
    fi;
  done
done
