FROM python:latest

ENV STRONGSWAN_VERSION 5.9.3

RUN apt-get -y update \
&& apt-get -y install libssl-dev wget bzip2 make build-essential vim \
&& apt-get -y clean

RUN wget https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& tar xjvf strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& cd strongswan-$STRONGSWAN_VERSION \
&& ./configure --prefix=/usr --sysconfdir=/etc \
		--disable-gmp \
		--enable-vici \
		--enable-openssl \
		--enable-eap-identity \
		--enable-eap-md5 \
		--enable-eap-tls \
		--enable-eap-ttls \
		--enable-eap-peap \
		--enable-eap-dynamic > /dev/null 2>&1 \
&& make -j > /dev/null 2>&1 \
&& make install > /dev/null 2>&1 \
&& cd - && rm -rf strongswan-*

COPY . /strongMan/

RUN cd /strongMan \
&& pip install --upgrade pip \
&& pip install -r requirements.txt

# assuming the repo root as context
COPY docker/gateway/swanctl /etc/swanctl/
COPY docker/gateway/strongswan.conf /etc/strongswan.conf
