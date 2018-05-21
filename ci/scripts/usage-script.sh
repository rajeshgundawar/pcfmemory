#!/bin/sh
cf login -a $API_URL -u $USERNAME -p $PASSWORD -o $ORG
echo "Running cf usage report"
cf usage-report >usage_report.txt
ls -ltra
mem_usage=$(cat usage_report.txt | grep $ORG| cut -d' ' -f5) 
mem_quota=$(cat usage_report.txt | grep $ORG| cut -d' ' -f8)
percentage_usage=$((100*$mem_usage/$mem_quota))
if [ "$percentage_usage" -lt "$THRESHOLD" ]
then
 echo "Existing Memory Usage is $percentage_usage is below threshold"
 echo "End of Task"
 exit 0;
else
 echo "Existing Memory Usage is $percentage_usage is above threshold:$THRESHOLD"
 echo "Preparing Email content"
 date
 subject="$ENV environment $ORG Org Memory Usage is above Threshold $THRESHOLD%"
 to="$TO" 
 body="Existing Memory Usage is percentage_usage is above threshold:THRESHOLD"
 echo $body |mailx -s "$subject" pavan@techolution.com
 echo "End of task"
fi
