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


LC_TEMPLATE_FILE=template/mist-worker-launchconfiguration.json
AS_TEMPLATE_FILE=template/mist-worker-services.json

ORIG_LAUNCH_CONFIG_NAME=MistMasterLaunchConfiguration
ORIG_INSTANCE_SECURITY_GROUP=InstanceSecurityGroup
ORIG_AUTO_SCALING=MistMasterInstanceAsg
MASTER_ROLE_NAME=role_master

EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws configure set default.region $EC2_REGION
ORIGINAL_TEMPLATE=$(aws cloudformation get-template --stack-name $STACK_NAME | jq .TemplateBody)


##add spark slaves
launchConfiguration=$(cat $LC_TEMPLATE_FILE)
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__RESOURCE_NAME__/$launchCName/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__TYPE__/SparkSlave/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__NAMESPACE__/$ARG_NAMESPACE/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__INSTANCE_ROLE__/role_spark_slave/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__INSTANCE_COUNT__/$SPARK_SLAVE_SCOUNT/g")

ADD="$launchConfiguration"

##add worker
launchConfiguration=$(cat $LC_TEMPLATE_FILE)
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__RESOURCE_NAME__/$launchCName/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__TYPE__/Worker/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__NAMESPACE__/$ARG_NAMESPACE/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__INSTANCE_ROLE__/role_worker/g")
launchConfiguration=$(echo $launchConfiguration | sed -e "s/__INSTANCE_COUNT__/1/g")

ADD="$ADD , $launchConfiguration"