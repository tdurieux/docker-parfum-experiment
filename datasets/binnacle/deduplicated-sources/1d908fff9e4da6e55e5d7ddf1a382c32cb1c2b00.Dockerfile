FROM debian:jessie
MAINTAINER Slavik Markovich <slavik@demisto.com>

ENV CLAMAV_VERSION 0.99

RUN echo "deb http://http.debian.net/debian/ jessie main contrib non-free" > /etc/apt/sources.list && \
  echo "deb http://http.debian.net/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    clamav-daemon=${CLAMAV_VERSION}* \
    clamav-freshclam=${CLAMAV_VERSION}* \
    libclamunrar7 \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
  wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
  wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
  chown clamav:clamav /var/lib/clamav/*.cvd

RUN mkdir /var/run/clamav && \
  chown clamav:clamav /var/run/clamav && \
  chmod 750 /var/run/clamav

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

VOLUME ["/var/lib/clamav"]

COPY run.sh /
COPY g-worker.conf /etc/g-worker.conf
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY worker /
COPY build-date /

CMD ["/run.sh"]
