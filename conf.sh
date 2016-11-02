#!/bin/bash

##REPLICATE_SERVER=http://planet.osm.org/replication/minute
REPLICATE_SERVER=http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/
PLANET_FILE="http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/planet/planet-latest.osm.bz2"
OPASS_MAIN=/Overpass-API
BINDIR=$OPASS_MAIN/src/bin
EXECDIR=$OPASS_MAIN/src
DBDIR=/overpass_DB

RULES_LOGFILE=$DBDIR/rules_loop.log

