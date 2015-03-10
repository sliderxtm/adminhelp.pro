#!/bin/sh

####
####  Published by http://www.adminhelp.pro
####


doveadm=`which doveadm 2>/dev/null`

function help {
echo -e "\n\tThis plugin check quota usage for all users and display overlimit users. \n\n$0:\n\t-w <%>\tSets the WARNING usage in percent\n"
	exit -1
}

# Getting parameters:
while getopts "w:c:h" OPT; do
        case $OPT in
                "w") warning=$OPTARG;;
                "h") help;;
        esac
done

# Checking parameters:
[ "$warning" == "" ] && echo "ERROR: You must specify warning level" && help

result=`sudo $doveadm -f tab quota get -A 2>/dev/null | grep STORAGE | awk -v warn=$warning '{if ($6 > warn) print  $1":"$6"%;"}'`

if [ "$result" != "" ]; then
    echo "WARNING quota limit alert: some quota exceed $warning% usage;  see long output;"
    for i in $result; do
        echo $i
    done
    exit 1
else
    echo "OK. all quota limits are not exceeded"
    exit 0
fi
