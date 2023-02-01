FROM coinvault/client-base:latest

MAINTAINER Dan Gershony - CoinVault <dan@coinvault.io>

# dependencies required to run the daemon
RUN apt-get update \
	&& apt-get install --no-install-recommends -y git \
	&& apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake \
	&& apt-get install --no-install-recommends -y pkg-config libssl-dev libevent-dev bsdmainutils \
	&& apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# get
RUN    apt-get update \
       && cd ~ \
       && git clone https://github.com/namecoin/namecoin-core.git namecoin

# build
RUN cd ~/namecoin \
	&& ./autogen.sh \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-wallet --without-gui --without-miniupnpc \
	&& make

# install
RUN cd ~/namecoin/src \
    && strip namecoind \
    && install -m 755 namecoind /usr/local/bin 

RUN  mkdir /root/.namecoin/

COPY  namecoin.conf /root/.namecoin/

VOLUME /root/.namecoin

WORKDIR /usr/local/bin

EXPOSE 5000

CMD ["namecoind"]
