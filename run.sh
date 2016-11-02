#!/bin/bash

source conf.sh


#delete lockfiles
rm $DBDIR/osm3s*

./clone_db.sh #If it doesn't exist, clone it

#run the dispatcher
$BINDIR/dispatcher --osm-base --meta --db-dir=$DBDIR &
chmod 666 $DBDIR/osm3s_v0.7.52_osm_base
sleep 5 #In case

#start apache for queries
service apache2 start

#run the diff fetcher
$BINDIR/fetch_osc_and_apply.sh $REPLICATE_SERVER --meta=yes &


#AREAS
cp -pR $OPASS_MAIN/src/rules $DBDIR/
$BINDIR/dispatcher --areas --db-dir=$DBDIR &
chmod 666 $DBDIR/osm3s_v0.7.52_areas
sleep 5
$BINDIR/rules_loop.sh $DBDIR &



while true; do
	sleep 2000;
done
