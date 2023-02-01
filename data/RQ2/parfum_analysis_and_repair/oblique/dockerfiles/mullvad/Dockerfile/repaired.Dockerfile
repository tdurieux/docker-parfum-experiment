FROM debian

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install curl dbus && \
    curl -f -L -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    apt-get -y --no-install-recommends install ./mullvad.deb && \
    rm -f mullvad.deb && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /config

ADD my_init /
CMD ["/my_init"]
