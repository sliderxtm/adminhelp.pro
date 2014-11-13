#!/bin/sh

backup_patch=$1
prog=`basename $0`
pid="/var/run/$prog.pid"
HOST=`hostname`
secret="/home/backup/pass.key"
LIST_CONTENT_TO_BACKUP="/var/www /etc"

if [ ! -d "$backup_patch" -o "$backup_patch" = "" ]; then 
    echo "Directory to backup not found"
    exit 1
fi

if [ -f $pid ]; then
    echo "WARNING: $prog script still running!"
    exit 1
fi

echo $$ > $pid


cd /var/lib/mysql

DIRB="$backup_patch/$HOST/"

mkdir -p $DIRB



for content in $LIST_CONTENT_TO_BACKUP;do 

month=$(/bin/date +%m)
day=$(/bin/date +%d)

filename=`echo $content | tr [/] [.]`
tar -czf - $content | openssl enc -e -aes-256-cbc -pass file:$secret > $DIRB/${month}.${day}.$filename.tar.gz.encrypted

    for month in $(/bin/date -d '3 month ago' +%m) $(/bin/date -d '4 month ago' +%m) $(/bin/date -d '5 month ago' +%m) $(/bin/date -d '6 month ago' +%m);do
	if [ -f $DIRB/$DIRB/${month}.${day}.$filename.tar.gz.encrypted ]; then
    	    rm -f $DIRB/${month}.${day}.$filename.tar.gz.encrypted
	fi
    done

done

rm -f $pid

exit 0
