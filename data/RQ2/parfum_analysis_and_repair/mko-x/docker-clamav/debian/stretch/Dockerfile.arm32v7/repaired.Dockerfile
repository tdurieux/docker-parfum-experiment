FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm32v7/debian:stretch-slim as release
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# copy qmeu
COPY --from=qemu qemu-arm-static /usr/bin

# Debian Base to use
ENV DEBIAN_VERSION stretch

# initial install of av daemon
RUN echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ $DEBIAN_VERSION/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
        clamav-daemon \
        clamav-freshclam \
        libclamunrar9 \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# initial update of av databases
# disabled - see https://github.com/mko-x/docker-clamav#prefer-alpine-idb-amd64
# RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
#    wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
#    wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
#    chown clamav:clamav /var/lib/clamav/*.cvd

# permission juggling
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    if ! [ -z $HTTPProxyServer ]; then echo "HTTPProxyServer $HTTPProxyServer" >> /etc/clamav/freshclam.conf; fi && \
    if ! [ -z $HTTPProxyPort   ]; then echo "HTTPProxyPort $HTTPProxyPort" >> /etc/clamav/freshclam.conf; fi && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

# port provision
EXPOSE 3310

COPY bootstrap.sh /
RUN chown clamav:clamav bootstrap.sh && \
    chmod u+x bootstrap.sh

USER clamav

CMD ["/bootstrap.sh"]