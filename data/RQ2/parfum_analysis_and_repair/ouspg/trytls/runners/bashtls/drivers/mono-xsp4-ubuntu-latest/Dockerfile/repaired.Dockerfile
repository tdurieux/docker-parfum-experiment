FROM ubuntu:latest

RUN apt-get -y --allow-unauthenticated update && \
  apt-get -y --no-install-recommends --allow-unauthenticated install \
  mono-xsp4 && rm -rf /var/lib/apt/lists/*;

COPY scripts /scripts

CMD bash scripts/init; bash '/etc/shared/scripts/drive'
