#!/bin/sh
echo "Loginig into CF CLI"
cf login -a $API_URL -u $USERNAME -p $PASSWORD -o $ORG
echo "Running cf usage report"
cf usage-report >usage_report.txt
mem_usage=$(cat usage_report.txt | grep $ORG| cut -d' ' -f5); echo "$ENV Usage is $mem_usage"
mem_quota=$(cat usage_report.txt | grep $ORG| cut -d' ' -f8); echo "$ENV Quota is $mem_quota"
percentage_usage=$((100*$mem_usage/$mem_quota)); echo "$percentage_usage% is usage of $ENV"
if [ "$percentage_usage" -lt "$THRESHOLD" ]
then
 echo "Existing Memory Usage is $percentage_usage is below threshold"
 echo "End of Task"
 echo "false">email/trig
 echo "$TO" >email/usr
 echo "$ORG Org Current Memory Utlization is $percentage_usage%">email/body
 echo "$ENV environment $ORG Org Memory Usage is below Threshold $THRESHOLD%" >email/subject
 echo $trig
 cat email/trig
 exit 0;
else
 echo "$ORG Org Current Memory Utlization is $percentage_usage%">email/body
 date
 echo  "Printing Body of Email"
 cat email/body
 echo "$ENV environment $ORG Org Memory Usage is above Threshold $THRESHOLD%" >email/subject
 cat email/subject
 echo "$TO" >email/usr
 cat email/usr
 echo "Done with preparing of Email"
 echo "End of task"
 echo "true">email/trig
 cat email/trig
fi
