#!/bin/bash

set -e
cd ${MIST_HOME}

if [ "$1" = 'master' ]; then
  ./bin/mist start master --config $MIST_CONFIG
elif [ "$1" = 'worker' ]; then
  $SPARK_HOME/sbin/start-master.sh -h 0.0.0.0
  ./bin/mist start worker --runner local --namespace $NAMESPACE --config $MIST_CONFIG $RUN_OPTIONS
elif [ "$1" = 'spark-slave' ]; then
  $SPARK_HOME/sbin/start-slave.sh $2
  PID=`cat /tmp/spark-*.pid`
  while ps -p $PID > /dev/null
  do
    sleep 60
  done
else
  exec "$@"
fi
