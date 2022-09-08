#!/bin/bash
for file in `ls ./*.ibd`
do
    if test -f $file
    then
        # cd /qhdata/server/mysql/data/qhdata_warehouse_v2/
        /qhdata/server/mysql/mysql/bin/ibd2sdi $file   --type=1 --dump-file=/qhdata/json/qhdata_warehouse_v2/$file.json
    fi
done