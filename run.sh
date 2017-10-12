#!/bin/bash

source conf.sh


exitGracefully() {
	service apache2 stop
	pkill fetch_osc_and_apply
	sleep 8
	pkill osm-base
}

trap exitGracefully EXIT

sleep 20


#Configure apache contact values + index.html
sed -i "s/VHOST_EMAIL/$VHOST_EMAIL/g" /etc/apache2/sites-enabled/vhost_apache.conf || true
sed -i "s/VHOST_FQDN/$VHOST_FQDN/g" /etc/apache2/sites-enabled/vhost_apache.conf || true

sed -i "s/VHOST_EMAIL/$VHOST_EMAIL/g" /www/index.html || true


#start apache for queries
service apache2 start

#delete lockfiles
rm $DBDIR/osm3s*

#make sure DBDIR is readable by overpass_api user
chmod uog+rw $DBDIR
chmod uog+rw $DBDIR/*

su overpass_api -c '/launch_overpass.sh'

