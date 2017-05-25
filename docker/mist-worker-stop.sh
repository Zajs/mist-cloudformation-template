#!/bin/bash

shift
while [[ $# > 1 ]]
do
  key="$1"

  case ${key} in
    --namespace)
      ARG_NAMESPACE="$2"
      shift
      ;;

    --jar)
      ARG_JAR="$2"
      shift
      ;;

    --config)
      ARG_CONFIG="$2"
      shift
      ;;

    --run-options)
      ARG_RUN_OPTIONS="$2"
      shift
      ;;
  esac

shift
done

EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws configure set default.region $EC2_REGION
ORIGINAL_TEMPLATE=$(aws cloudformation get-template --stack-name $STACK_NAME | jq .TemplateBody)

echo "LCSparkSlave$ARG_NAMESPACE"
echo "ASGroupSparkSlave$ARG_NAMESPACE"
echo "LCWorker$ARG_NAMESPACE"
echo "ASGroupWorker$ARG_NAMESPACE"
echo "SparkSlaveService$ARG_NAMESPACE"
echo "MistWorkerService$ARG_NAMESPACE"
echo "SparkSlavesTaskDefinition$ARG_NAMESPACE"
echo "WorkerTaskDefinition$ARG_NAMESPACE"