FROM python:latest

ENV STRONGSWAN_VERSION 5.9.3

RUN apt-get -y update \
&& apt-get -y --no-install-recommends install libssl-dev wget bzip2 make build-essential vim \
&& apt-get -y clean && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& tar xjvf strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& cd strongswan-$STRONGSWAN_VERSION \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc \
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
&& cd - && rm -rf strongswan-* && rm strongswan-$STRONGSWAN_VERSION.tar.bz2

COPY . /strongMan/

RUN cd /strongMan \
&& pip install --no-cache-dir --upgrade pip \
&& pip install --no-cache-dir -r requirements.txt

# assuming the repo root as context
COPY docker/gateway/swanctl /etc/swanctl/
COPY docker/gateway/strongswan.conf /etc/strongswan.conf
