#!/bin/sh

backup_patch=$1
prog=`basename $0`
pid="/var/run/$prog.pid"
HOST=`hostname`
secret="/home/backup/pass.key"

if [ ! -d "$backup_patch" -o "$backup_patch" = "" ]; then 
    echo "Directory to backup not found"
    exit 1
fi

if [ -f $pid ]; then
    echo "WARNING: $prog script still running!"
    exit 1
fi

echo $$ > $pid

month=$(/bin/date +%m)
day=$(/bin/date +%d)
cd /var/lib/mysql

DIRB="$backup_patch/$HOST/mysql"

mkdir -p $DIRB/$month/$day

cd /var/lib/mysql
LIST=`find * -type d`

for basname in $LIST;do 

/usr/bin/mysqldump --add-locks $basname | gzip -9 | openssl enc -e -aes-256-cbc -pass file:$secret > $DIRB/${month}/${day}/$basname.gz.encrypted

done

for month in $(/bin/date -d '3 month ago' +%m) $(/bin/date -d '4 month ago' +%m) $(/bin/date -d '5 month ago' +%m) $(/bin/date -d '6 month ago' +%m);do
    if [ -d $DIRB/$month ]; then
        cd $DIRB/$month && rm -rf *
    fi
done

rm -f $pid

exit 0
