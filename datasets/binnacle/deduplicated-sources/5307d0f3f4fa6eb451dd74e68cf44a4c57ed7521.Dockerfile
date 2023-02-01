FROM debian:jessie

## The Data from the official point release.
ENV ioquake_data linuxq3apoint-1.32b-3.x86.run

RUN echo "deb http://httpredir.debian.org/debian jessie contrib" >> /etc/apt/sources.list && \
        apt-get update && \
        apt-get install -y quake3-server \
        wget && \
            apt-get clean

RUN rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/locale/* \
        /var/cache/debconf/*-old \
        /var/lib/apt/lists/* \
        /usr/share/doc/*

WORKDIR /usr/share/games/quake3

RUN wget "http://youfailit.net/pub/idgames/idstuff/quake3/linux/${ioquake_data}" && \
        chmod +x ${ioquake_data} && \
        ./${ioquake_data} --tar xvf && \
        rm -rf ./${ioquake_data}

USER Debian-quake3

EXPOSE 27960/udp

ENTRYPOINT ["/usr/games/quake3-server"]

CMD ["+map", "q3dm17", "+exec", "server.cfg"]
