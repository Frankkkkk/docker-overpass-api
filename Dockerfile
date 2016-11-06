FROM ubuntu:16.04

RUN apt-get update #

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
	bzip2 \
	wget \
	liblz4-1 liblz4-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/drolbr/Overpass-API.git

WORKDIR /Overpass-API/src
RUN \
	autoscan && \
	aclocal-1.11 && \
	autoheader && \
	libtoolize && \
	automake-1.11 --add-missing && \
	autoconf

RUN \
	./configure --enable-lz4 CXXFLAGS="-O3" --prefix="`pwd`" && \
	make -j `nproc --all`


COPY vhost_apache.conf /etc/apache2/sites-available
RUN a2enmod ext_filter cgi
RUN a2dissite 000-default.conf
RUN a2ensite vhost_apache.conf

WORKDIR /

COPY *.sh /

ADD www /www

CMD ["/run.sh"]

VOLUME "/overpass_DB"
EXPOSE 80


