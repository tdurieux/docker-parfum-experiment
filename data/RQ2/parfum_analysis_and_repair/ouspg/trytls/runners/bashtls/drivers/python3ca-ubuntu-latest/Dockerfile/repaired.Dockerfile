FROM ubuntu:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  python3.5 \
  python-pip && rm -rf /var/lib/apt/lists/*;

CMD bash '/etc/shared/scripts/drive'
