#!/bin/bash

source conf.sh

#delete lockfiles
rm $DBDIR/osm3s*

#run the dispatcher
$BINDIR/dispatcher --osm-base --meta --db-dir=$DBDIR &

#start apache for queries
service apache2 start

sleep 5 #In case


###AREAS
#copy the rules
cp -r $OPASS_MAIN/rules $DBDIR/

#run the areas dispatcher
$BINDIR/dispatcher --areas --db-dir=$DBDIR &
areas_pid=$!
renice -n 19 -p $areas_pid
ionice -c 2 -n 7 -p $areas_pid
chmod 666 $DBDIR/osm3s_v0.7.52_areas

sleep 5 #In case

#rule creation loop, infinite
/low_prio_rules_loop.sh $DBDIR &


#DIFFS

#run the diff fetcher TODO
#$BINDIR/fetch_osc_and_apply.sh $REPLICATE_SERVER --meta=yes &


while true; do
	sleep 2000;
done
