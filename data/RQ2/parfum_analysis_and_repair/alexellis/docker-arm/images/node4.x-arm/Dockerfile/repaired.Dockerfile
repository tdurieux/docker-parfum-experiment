FROM armhf/ubuntu
RUN apt-get update && \
    apt-get -qy --no-install-recommends install wget unzip \
                build-essential python && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/
RUN wget \
  https://nodejs.org/dist/v4.2.4/node-v4.2.4-linux-armv7l.tar.gz
RUN tar -xvf node-v4.2.4-linux-armv7l.tar.gz -C /usr/local \
  --strip-components=1 && rm node-v4.2.4-linux-armv7l.tar.gz

CMD ["node"]
