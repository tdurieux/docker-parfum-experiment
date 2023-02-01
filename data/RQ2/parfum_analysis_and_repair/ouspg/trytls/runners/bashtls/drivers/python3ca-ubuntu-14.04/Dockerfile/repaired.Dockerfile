FROM ubuntu:14.04

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  python3 \
  python-pip && rm -rf /var/lib/apt/lists/*;


CMD bash '/etc/shared/scripts/drive'
