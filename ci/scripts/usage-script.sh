#!/bin/sh
echo "Loginig into CF CLI"
cf login -a $API_URL -u $USERNAME -p $PASSWORD -o $ORG -s $SPACE
echo "Running cf usage report"
cf usage-report >usage_report.txt
mem_usage=$(cat usage_report.txt | grep $ORG| cut -d' ' -f5); echo "$SPACE Usage is $mem_usage"
mem_quota=$(cat usage_report.txt | grep $ORG| cut -d' ' -f8); echo "$SPACE Quota is $mem_quota"
percentage_usage=$((100*$mem_usage/$mem_quota)); echo "$percentage_usage% is usage of $SPACE"
if [ "$percentage_usage" -lt "90" ]
then
 echo "Existing Memory Usage is $percentage_usage is below threshold"
 echo "End of Taski"
 exit 0;
else
 echo "Percentage of $SPACE  Usage is $percentage_usage%">email/body
 date
 echo  "Printing Body of Email"
 cat email/body
 echo "$ENV Memory Usage is above Threshold" >email/subject
 cat email/subject
 echo "$TO" >email/usr
 cat email/usr
 echo "Done with preparing of Email"
 echo "End of task"
fi
