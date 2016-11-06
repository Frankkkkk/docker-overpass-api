#!/bin/bash

source conf.sh

space=`du -s $DBDIR | cut -f1`
if [ ! -e $DBDIR/nodes.bin ]; then
	#Database doesn't exist
	cd $DBDIR

	#Get actual last replication state
	wget -O /dev/shm/state.txt "http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/state.txt"

	#Download the planet
	wget -O planet.osm.bz2 $PLANET_FILE

	#init the planet
	$BINDIR/init_osm3s.sh $DBDIR/planet.osm.bz2 $DBDIR $EXECDIR --meta

	#Get 7 days of backwards history; we never know when was the planet.osm exported..
	NUM=`cat /dev/shm/state.txt | grep sequenceNumber | cut -d'=' -f2`

	#Write the replicate id, 7 days before
	echo $(($NUM - 1440*7)) > $DBDIR/replicate_id
fi
