FROM ubuntu:precise
LABEL maintainer="Arkadi Shishlov <arkadi.shishlov@gmail.com>"
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ libncurses5-dev uuid-dev libxml2-dev libsqlite3-dev libssl-dev libedit-dev ca-certificates wget make file bzip2 patch && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp \
    && wget -nv -O - https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz | tar xz
ADD mkast.sh /tmp/
RUN cd /tmp/asterisk-* \
    && /tmp/mkast.sh /opt/asterisk
VOLUME /opt/intel2
VOLUME /opt/asterisk-g72x
