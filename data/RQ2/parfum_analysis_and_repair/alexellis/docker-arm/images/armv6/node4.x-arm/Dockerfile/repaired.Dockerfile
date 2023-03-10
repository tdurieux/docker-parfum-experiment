FROM resin/rpi-raspbian
RUN apt-get update && \
    apt-get -qy --no-install-recommends install wget unzip \
                build-essential python \
                ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/
RUN wget \
  https://nodejs.org/dist/v4.4.0/node-v4.4.0-linux-armv6l.tar.gz
RUN tar -xvf node-*.tar.gz -C /usr/local \
  --strip-components=1 && rm node-*.tar.gz

CMD ["node"]
