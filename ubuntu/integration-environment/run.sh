#!/bin/bash

LATEST=`ls -t /opt/graylog/assembly/graylog-* | head -n1`

if [ ! -f "$LATEST" ]
then
  echo "Cannot find Graylog server bundle: $LATEST"
  echo "Instead there is:"
  find /opt/graylog/assembly
  exit 1
fi

mkdir -p /opt/graylog/server
tar xzvfC $LATEST /opt/graylog/server --strip 1

/sbin/my_init
