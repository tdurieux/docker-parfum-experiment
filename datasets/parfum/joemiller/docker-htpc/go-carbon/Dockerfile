FROM ubuntu:20.04

ENV GO_CARBON_PKG_URL https://github.com/lomik/go-carbon/releases/download/v0.9.1/go-carbon_0.9.1_amd64.deb

RUN apt-get update -q \
  && apt-get install -qy \
    wget \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

RUN cd /tmp \
  && wget -q "${GO_CARBON_PKG_URL}" \
  && dpkg -i /tmp/*.deb \
  && rm -rf /tmp/*

EXPOSE 2003 2004 7002 7007 8080 2003/udp
VOLUME /data

ADD carbon.conf          /config/carbon.conf
ADD storage-schemas.conf /config/storage-schemas.conf

CMD ["go-carbon", "-config", "/config/carbon.conf"]
