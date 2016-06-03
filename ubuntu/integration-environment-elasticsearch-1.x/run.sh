#!/bin/bash

if [ -z "$1" ]
then
  echo "Provide a path to Graylog server bundle!"
  exit 1
fi

LATEST=`ls -t $1/graylog-*.tar.gz | head -n1`

if [ ! -f "$LATEST" ]
then
  echo "Cannot find Graylog server bundle: $LATEST"
  echo "Instead there is:"
  find $1
  exit 1
fi

mkdir -p /opt/graylog/server
tar -xzvf "$LATEST" -C /opt/graylog/server --strip 1

/sbin/my_init --no-kill-all-on-exit &

echo "Waiting for Graylog server"
until $(curl --output /dev/null --silent --head --fail http://localhost:12900/api-browser); do
    printf '.'
    sleep 5
done
