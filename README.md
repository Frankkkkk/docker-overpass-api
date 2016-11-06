# Overpass API docker image

## What is it ?
Its actually a full install of the [overpass api server](http://overpass-api.de/). It supports:

*  Database clone from the planet.osm files
* metadata support
* Minute updates
* Area creation and updates
* API access over apache

## How to run
The easiest way is to simply type `make`.
I don't know about docker volumes, so the makefile specifies where the DB should be stored on your server. By default, the path is `/mnt/ssd/overpass_DB`. You can change this path by changing the `OVERPASS_DB_DIR` variable (or you can use docker volumes if you know how to).

Also, you can specify a different bind port for the web interface by changing the `-p 5001:80` variable. That means that it will be accessible at your server's ip, port `5001`. You can change that to `80`, `8080` or any other number if you use a proxy between the internet and your docker web instances.

## How long will it take
On my server (16Gb of ram, i7-2600@3.4GHz, SSD), the initial export took ~ 40hours, then about 24h to get to the actual replication state.

## More things to tweak
You can add your custom web pages to the www directory and change your domain/email address on the `vhost_apache.conf` file.

Also, if you dont live "network-near" Germany, you could additionaly change the FTP server in the `conf.sh` file.
