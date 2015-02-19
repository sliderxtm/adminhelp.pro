#!/bin/sh

email=$1



# $7=sender, $8=recipient1, $9=recipient2

mailq | tail -n +2 | grep -v "^ *(" | awk  'BEGIN { RS = "" } { if ($8 == "'"$email"'" && $9 == "") print $1 }' | tr -d "*!" | postsuper -d -
