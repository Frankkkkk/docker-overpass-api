# Overpass API docker image

## What is it ?
Its actually a full install of the [overpass api server](http://overpass-api.de/). It supports:

* Database clone from the planet.osm files
* metadata support
* Minute updates
* Area creation and updates
* API access over apache (http://URL/api/timestamp , http://URL/api/interpreter)

## How to run using standard Docker commands
You can simply build the Docker image by `docker build -t overpass_api .` and the run the docker container by `docker run -d --restart=always -v <PATH TO THE OVERPASS DB ON HOST>:/overpass_DB -p 80:80 overpass_api`.
NOTE: After the server start up you have to wait several minutes (or hours depending on the planet size) until the DB is loaded. In order to check the status you can use `docker logs` command.

## How to run using makefile
The easiest way is to simply type `make`.
I don't know about docker volumes, so the makefile specifies where the DB should 
be stored on your server. By default, the path is `/mnt/ssd/overpass_DB`. You 
can change this path by changing the `conf.sh` file (or you can use docker 
volumes if you know how to).

Also, you can specify a different bind port for the web interface by changing 
the `SERVER_HTTP_PORT` variable (still in `conf.sh`). That means that it will be 
accessible at your server's IP, port `5001`. You can change that to `80`, `8080` 
or any other number if you use a proxy between the internet and your docker web 
instances.

## How long will it take
First you have to download the planet.osm image. It weighs about 54G. Depending 
on your connection it may be as quick as three hours.
On my server (16Gb of ram, i7-2600@3.4GHz, SSD), the initial export took ~ 
40hours, then about 24h to get to the actual replication state (it is usable 
after the 40 hours, even if the server is behind state).  The whole clone weighs 
about 240Gb.

## More things to tweak
You can add your custom web pages to the www directory and change your 
domain/email address on the `conf.sh` file.

Also, if you don't live "network-near" Germany, you could additionally change 
the FTP server in the `conf.sh` file.

