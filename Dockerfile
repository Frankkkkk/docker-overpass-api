FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y apache2 vim

RUN apt-get install -y \
	autoconf \
	automake1.11 \
	expat \
	git \
	g++ \
	libtool \
	libexpat1-dev \
	make \
	zlib1g-dev \
	wget

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/drolbr/Overpass-API.git
WORKDIR /Overpass-API
RUN git config --global user.email "you@example.com"
RUN git checkout osm3s-v0.7.52
#Merge commit for delta areas
RUN git merge --no-edit -q 42b5962b10c948bbdfeaf9c7d3d45b9f8154d158

WORKDIR /Overpass-API/src
RUN \
	autoscan && \
	aclocal-1.11 && \
	autoheader && \
	libtoolize && \
	automake-1.11 --add-missing && \
	autoconf

RUN \
	./configure CXXFLAGS="-O3" --prefix="`pwd`" && \
	make -j `nproc --all`


COPY vhost_apache.conf /etc/apache2/sites-available
RUN a2enmod ext_filter cgi
RUN a2dissite 000-default.conf
RUN a2ensite vhost_apache.conf

WORKDIR /

COPY *.sh /

CMD ["/run.sh"]

EXPOSE 80


