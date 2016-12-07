#!/bin/bash

source conf.sh


exitGracefully() {
	kill $(ps aux | grep fetch_osc_and_apply | awk '{print $2}')
	sleep 8
	kill $(ps aux | grep osm-base | awk '{print $2}')
}

trap exitGracefully SIGTERM

sleep 20

sed -i "s/VHOST_EMAIL/$VHOST_EMAIL/g" /etc/apache2/sites-enabled/vhost_apache.conf || true
sed -i "s/VHOST_FQDN/$VHOST_FQDN/g" /etc/apache2/sites-enabled/vhost_apache.conf || true

sed -i "s/VHOST_EMAIL/$VHOST_EMAIL/g" /www/index.html || true


#delete lockfiles
rm $DBDIR/osm3s*

#If it doesn't exist, clone it
./clone_db.sh  2>&1 > /clone_db.log

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
