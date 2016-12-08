#!/bin/bash

source conf.sh


#If database doesn't exist, clone it
echo "WIll clone DB"
./clone_db.sh

echo "Will run dispatcher"

#run the dispatcher
$BINDIR/dispatcher --osm-base --meta --db-dir=$DBDIR &
chmod 666 $DBDIR/osm3s_v0.7.52_osm_base
sleep 5 #In case

echo "Will run diff fetcher"

#run the diff fetcher
$BINDIR/fetch_osc_and_apply.sh $REPLICATE_SERVER --meta=yes &


#AREAS
echo "Will run areas"
cp -pR $OPASS_MAIN/src/rules $DBDIR/
$BINDIR/dispatcher --areas --db-dir=$DBDIR &
chmod 666 $DBDIR/osm3s_v0.7.52_areas


sleep 5
echo "Will run rules loop"
$BINDIR/rules_loop.sh $DBDIR &



while true; do
	sleep 2000;
done
