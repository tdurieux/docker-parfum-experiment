FROM ubuntu:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  default-jre && rm -rf /var/lib/apt/lists/*;

COPY scripts /scripts

CMD bash scripts/init; bash '/etc/shared/scripts/drive'
