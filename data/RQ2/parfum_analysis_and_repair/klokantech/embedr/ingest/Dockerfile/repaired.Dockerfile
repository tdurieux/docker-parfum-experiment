FROM debian:7

COPY requirements.txt /usr/local/src/hawk/requirements.txt

RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install \
    memcached \
    python-pip \
    imagemagick \
    wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install libfcgi0ldbl \
    libgcc1 \
    libjpeg8 \
    libmemcached10 \
    libstdc++6 \
    libtiff4 \
	libpng12-0 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -q -r /usr/local/src/hawk/requirements.txt
RUN wget --no-verbose https://downloads.klokantech.com/iiifserver/iiifserver-1.0.0.debian-wheezy.amd64.deb
RUN dpkg -i iiifserver-1.0.0.debian-wheezy.amd64.deb
