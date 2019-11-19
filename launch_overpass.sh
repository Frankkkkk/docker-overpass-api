#!/bin/bash

source conf.sh

# Kill all background processes on exit
trap "exit" INT TERM
trap "kill 0" EXIT

#If database doesn't exist, fetch the .osm and init the overpass db
echo "Raw installation, will init DB from .osm planet"
./init_db_from_osm_planet.sh

echo "Will run dispatcher"

#run the dispatcher
$BINDIR/dispatcher --osm-base --meta --db-dir=$DBDIR &
sleep 5 #In case

echo "Will run diff fetcher"

#run the diff fetcher
$BINDIR/fetch_osc_and_apply.sh $REPLICATE_SERVER --meta=yes &


#AREAS
echo "Will run areas"
cp -pR $OPASS_MAIN/src/rules $DBDIR/
$BINDIR/dispatcher --areas --db-dir=$DBDIR &


sleep 5
echo "Will run rules loop"
$BINDIR/rules_loop.sh $DBDIR &



while true; do
	sleep 2000;
done
