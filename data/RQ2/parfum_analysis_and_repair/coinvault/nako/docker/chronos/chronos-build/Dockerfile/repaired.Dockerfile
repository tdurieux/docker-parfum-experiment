FROM coinvault/client-base:latest

MAINTAINER Dan Gershony - CoinVault <dan@coinvault.io>

# dependencies required to run the daemon
RUN apt-get update \
	&& apt-get install --no-install-recommends -y git \
	&& apt-get install --no-install-recommends -y libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev \
	&& apt-get install --no-install-recommends -y qt-sdk qt4-default \
	&& apt-get install --no-install-recommends -y libcurl3-dev \
	&& apt-get install --no-install-recommends -y libzip-dev && rm -rf /var/lib/apt/lists/*;

# get
RUN apt-get update \
    && cd ~ \
	&& git clone https://github.com/dangershony/Chronoscoin.git 

# build
RUN	cd ~/Chronoscoin/src \
	&& mkdir -p obj \
	&& chmod 755 leveldb/build_detect_platform \
	&& make -f makefile.unix USE_UPNP=-

# install
RUN cd ~/Chronoscoin/src \
    && strip chronosd \
	&& install -m 755 chronosd /usr/local/bin 

# clean
RUN apt-get purge -y --auto-remove git \
  && rm -r ~/Chronoscoin