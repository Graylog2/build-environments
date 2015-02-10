#!/bin/bash

export DOCKER_HOST=${DOCKER_HOST:-'unix:///var/run/docker.sock'}

for DISTRIBUTION in */
do
  for CONTAINER_NAME in ${DISTRIBUTION}*
  do
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
