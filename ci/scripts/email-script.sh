#!/bin/sh
echo "Preparing Email to Send"
echo "$ENV Memory Usage is above Threshold" >email-out/generated-subject
cp email/body  email-out/body
echo $TO>email-out/usr
echo "Email Body"
cat email-out/body
echo "Emai Subject"
cat email-out/generated-subject
echo "Receipt"
cat email-out/usr
echo "Preparation to send email completed"
