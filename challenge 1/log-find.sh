#!/bin/bash

#Set directory containing log files
#LOGDIR="/var/log/nginx/"
LOGDIR="/home/log/"
ERROR_CODE=500

#Iterate through each log file
for log in $(ls $LOGDIR)
do


COUNT=$(tail -600 $LOGDIR$log |grep $ERROR_CODE -c )

   #Print the log name and the number of errors
   echo "Log Name: $log | HTTP 500 errors found in the last 10 Minutes: $COUNT"
done
