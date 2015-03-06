#!/bin/sh

MEGASYNC='/usr/local/bin/megasync'
MEGARM='/usr/local/bin/megarm'
LOCALDIR="/usr/local/data/backups"
REMOTEDIR="/Root/albertolarripa/backups"
SEDLOCALDIR="\/usr\/local\/data\/backups"
SEDREMOTEDIR="\/Root\/albertolarripa\/backups"
BACKUP_TIME=`date +%c`
LOG="/usr/local/data/backups/mega.log"
hostname=`hostname`

#Obtain the files that not exists in the local server

DELETE=`$MEGASYNC --dryrun --reload --download --local $LOCALDIR --remote $REMOTEDIR | sed 's/F '$SEDLOCALDIR'/'$SEDREMOTEDIR'/g'`

# And remove it

for i in $DELETE; do
        $MEGARM $i
done

# Run the synchronization to Mega

SYNC=`$MEGASYNC --no-progress --local $LOCALDIR --remote $REMOTEDIR`

echo "[$BACKUP_TIME][$(hostname)] synchronization to mega done!!" > $LOG
echo "Files removed $DELETE" >> $LOG
echo "Files synchronized" >> $LOG
