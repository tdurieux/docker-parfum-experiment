FROM debian:buster
MAINTAINER Daniel da Silva <mail@danieldasilva.org>

# Make & install
RUN apt-get update && apt-get install --no-install-recommends bitlbee-dev bitlbee-libpurple bitlbee-plugin-otr git autoconf build-essential autoproject libtool glib2.0 glib2.0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN cd tmp && git clone https://github.com/sm00th/bitlbee-discord.git && cd bitlbee-discord && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Bitlbee config
EXPOSE 6667
VOLUME ["/var/lib/bitlbee"]
COPY bitlbee.conf /etc/bitlbee/bitlbee.conf
WORKDIR /
RUN chown -R bitlbee /var/lib/bitlbee/

ENTRYPOINT chown -R bitlbee /var/lib/bitlbee && /usr/sbin/bitlbee -n -c /etc/bitlbee/bitlbee.conf

