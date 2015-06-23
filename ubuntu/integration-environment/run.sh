#!/bin/bash

if [ -z "$1" ]
then
  echo "Provide a path to Graylog server bundle!"
  exit 1
fi

LATEST=`ls -t $1/graylog-* | head -n1`

if [ ! -f "$LATEST" ]
then
  echo "Cannot find Graylog server bundle: $LATEST"
  echo "Instead there is:"
  find $1
  exit 1
fi

mkdir -p /opt/graylog/server
tar xzvfC $LATEST /opt/graylog/server --strip 1

/sbin/my_init &

echo "Waiting for Graylog server"
until $(curl --output /dev/null --silent --head --fail http://localhost:12900/api-browser); do
    printf '.'
    sleep 5
done
