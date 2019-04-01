#!/bin/sh

target_dir="/target"

cd /source
CURPATH=`pwd`



if [ "$(ls -A $target_dir)" ]; then
    echo "Target volume filled already. No initial sync triggered."
else
     rsync -a /source/ /target/
fi


inotifywait -mr --exclude '(.git|.lock|.idea|_jb_old_|_jb_bak_)'  --timefmt '%d/%m/%y %H:%M:%s' --format '%T %e %w %f' -e close_write,modify,delete,create,move $CURPATH | \
while read date time action dir file; do

  FILECHANGE=${dir}${file}
  FILECHANGEREL=`echo "$FILECHANGE" | sed 's_'$CURPATH'/__'`

  echo "File changed: $FILECHANGE via: $action"
  if [[ "$action" =~ .*DELETE.* ]]; then
    rm -R $target_dir/$FILECHANGEREL 2> /dev/null
  else
    rsync --delete --relative -a $FILECHANGEREL $target_dir
  fi 
done