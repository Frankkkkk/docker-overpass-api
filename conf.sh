#!/bin/bash

#===================================
#You can change the following params
#===================================

#Where to store the database (without using a docker volume) in your server:
OVERPASS_DB_DIR=/mnt/ssd/overpass_DB

#On which server TCP port the API should be available ?
# i.e., the API will be accessible on http://YOUR_SERVER_IP:[PORT]/api
#Normally you want to have a proxy between the outside world and the API
SERVER_HTTP_PORT=5001


#What is your email ? So others can contact you in case
VHOST_EMAIL=your_email@example.net

#Your FQDN the server will be available on. Only for æsthetic purposes
VHOST_FQDN=overpass.server.example.net



#Which minute replication server should be used
REPLICATE_SERVER=http://planet.osm.org/replication/minute
#REPLICATE_SERVER=http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/


#Where to fetch the planet file from ?
#ftp.gwdg.de is fast in europe. If you are network-far away, you can change this
#url. Keep in mind that the file is ~50GB
PLANET_FILE="http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/planet/planet-latest.osm.bz2"





#=====================================
#Don't change anything below this line
#=====================================

OPASS_MAIN=/Overpass-API
BINDIR=$OPASS_MAIN/src/bin
EXECDIR=$OPASS_MAIN/src
DBDIR=/overpass_DB

RULES_LOGFILE=$DBDIR/rules_loop.log

