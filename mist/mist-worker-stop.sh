#!/usr/bin/env bash


requestMist="{
             \"family\": \"${EcsClusterName}-master\",
             \"containerDefinitions\": [
               {
                 \"name\": \"${EcsClusterName}-master\",
                 \"memory\": $[$memory-500],
                 \"cpu\": $[$cpu-250],
                 \"image\": \"hydrosphere/mist:ecs-${SparkVersion}\",
                 \"command\": [
                   \"mist-ecs\"
                 ],
                 \"links\": [
                   \"mosquitto:mosquitto\"
                 ],
                 \"essential\": true,
                 \"mountPoints\": [
                   {
                     \"sourceVolume\": \"mist-configs\",
                     \"containerPath\": \"/usr/share/mist/configs/\",
                     \"readOnly\": false
                   },
                   {
                     \"sourceVolume\": \"mist-jobs\",
                     \"containerPath\": \"/jobs/\",
                     \"readOnly\": false
                   }
                 ]
               },{
                 \"name\": \"mosquitto\",
                 \"memory\": 500,
                 \"cpu\": 250,
                 \"image\": \"ansi/mosquitto\",
                 \"essential\": true
               }
             ],
             \"volumes\": [
               {
                 \"name\": \"mist-configs\",
                 \"host\": {
                   \"sourcePath\": \"/mnt/efs/mist-configs\"
                 }
               },
               {
                 \"name\": \"mist-jobs\",
                 \"host\": {
                   \"sourcePath\": \"/mnt/efs/mist-jobs\"
                 }
               }
             ]
           }"