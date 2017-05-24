#!/bin/bash

set -e
cd ${MIST_HOME}

if [ "$1" = 'master' ]; then
    ls -l /usr/share/mist/configs/
    cat $MIST_CONFIG
  ./bin/mist start master --config $MIST_CONFIG
elif [ "$1" = 'worker' ]; then 
  echo worker
else
  exec "$@"
fi
