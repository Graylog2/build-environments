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
      cp ${file} "./${CONTAINER_NAME}/"
    done
    if [ -d "${CONTAINER_NAME}" ]; then
      LEGACY_ID=$(docker images | grep $CONTAINER_NAME | awk '{print $3}')
      echo "##################################################################"
      echo "# Building environment for ${CONTAINER_NAME}"
      echo "##################################################################"
      docker build --force-rm=true -t ${CONTAINER_NAME} ${CONTAINER_NAME}

      # Only delete the old image once the new one got successfully built
      if [[ ! -z "$LEGACY_ID" ]]; then
        echo "Delete existing image ${LEGACY_ID} - ${CONTAINER_NAME}"
        docker rmi -f ${LEGACY_ID} || true
      fi
    fi;
  done
done
