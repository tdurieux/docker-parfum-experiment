FROM raspbian/stretch as base

WORKDIR app

RUN apt-get update && \
    apt-get -qy --no-install-recommends install libboost-all-dev libqrencode-dev libssl-dev libdb5.3-dev libdb5.3++-dev libminiupnpc-dev dh-make build-essential zlib1g-dev libtool && rm -rf /var/lib/apt/lists/*;

COPY src /app

RUN STATIC=static make -f makefile.raspberrypi

FROM raspbian/stretch as app

WORKDIR app

COPY --from=base /app/curecoind /app/

VOLUME /root/.curecoin

CMD ['curecoind', '-printtoconsole']
