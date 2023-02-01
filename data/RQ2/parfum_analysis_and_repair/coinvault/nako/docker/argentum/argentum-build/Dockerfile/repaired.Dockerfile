FROM coinvault/client-base:latest

MAINTAINER Dan Gershony - CoinVault <dan@coinvault.io>

# dependencies required to run the daemon
RUN apt-get update \
	&& apt-get install --no-install-recommends -y git \
	&& apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake \
	&& apt-get install --no-install-recommends -y pkg-config libssl-dev libevent-dev bsdmainutils \
	&& apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
	#&& apt-get install -y libcurl3-dev \
	#&& apt-get install -y libzip-dev

# get
RUN apt-get update \
    && cd ~ \
	&& git clone https://github.com/argentumproject/argentum.git

# build
RUN cd ~/argentum \
	&& ./autogen.sh \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-wallet --without-gui --without-miniupnpc \
	&& make

# install
RUN cd ~/argentum/src \
    && strip argentumd \
	&& install -m 755 argentumd /usr/local/bin 

# clean
RUN apt-get purge -y --auto-remove git \
  && rm -r ~/argentum